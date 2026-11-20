-- ============================================================================
-- Semana 7 · Clase 13 · Tarea — SQL avanzado sobre el minimercado (PostgreSQL)
-- ============================================================================

-- Ejercicio 1: Crear vista detalle de ventas
CREATE OR REPLACE VIEW vista_detalle_ventas AS
SELECT
    v.id AS id_venta,
    v.fecha,
    c.nombre AS nombre_cliente,
    mp.nombre AS metodo_pago, -- Ajustar si el método de pago es columna directa en ventas
    p.nombre AS producto,
    pr.nombre AS proveedor,
    vp.cantidad,
    vp.precio_unitario,
    (vp.cantidad * vp.precio_unitario) AS subtotal
FROM ventas v
JOIN clientes c ON v.cliente_id = c.id
LEFT JOIN metodos_pago mp ON v.metodo_pago_id = mp.id
JOIN venta_productos vp ON v.id = vp.venta_id
JOIN productos p ON vp.producto_id = p.id
LEFT JOIN proveedores pr ON p.proveedor_id = pr.id;

SELECT * FROM vista_detalle_ventas;


-- Ejercicio 2: Consultas usando vista_detalle_ventas
-- 2a) Total gastado por cada cliente, de mayor a menor
SELECT
    nombre_cliente,
    COALESCE(SUM(subtotal), 0) AS total_gastado
FROM vista_detalle_ventas
GROUP BY nombre_cliente
ORDER BY total_gastado DESC;

-- 2b) Productos más vendidos (unidades), de mayor a menor
SELECT
    producto,
    COALESCE(SUM(cantidad), 0) AS unidades_vendidas
FROM vista_detalle_ventas
GROUP BY producto
ORDER BY unidades_vendidas DESC;


-- Ejercicio 3: Vista de productos con stock bajo (< 10 unidades)
CREATE OR REPLACE VIEW vista_stock_bajo AS
SELECT
    p.id,
    p.nombre,
    p.stock,
    pr.nombre AS nombre_proveedor,
    pr.telefono AS telefono_proveedor
FROM productos p
LEFT JOIN proveedores pr ON p.proveedor_id = pr.id
WHERE p.stock < 10;

SELECT *
FROM vista_stock_bajo
ORDER BY stock ASC;


-- Ejercicio 4: Vista materializada de ventas por mes
CREATE MATERIALIZED VIEW mv_ventas_por_mes AS
SELECT
    DATE_TRUNC('month', v.fecha)::DATE AS mes,
    COUNT(DISTINCT v.id) AS cantidad_ventas,
    COALESCE(SUM(vp.cantidad * vp.precio_unitario), 0) AS total_vendido
FROM ventas v
LEFT JOIN venta_productos vp ON v.id = vp.venta_id
GROUP BY DATE_TRUNC('month', v.fecha)::DATE
ORDER BY mes;

-- Consulta inicial
SELECT * FROM mv_ventas_por_mes;

-- Insertar una venta nueva (ajustar columnas según minimercado.sql)
INSERT INTO ventas (cliente_id, fecha)
VALUES (1, CURRENT_TIMESTAMP);

-- Volver a consultar antes del REFRESH (no cambia porque la vista materializada guarda un snapshot)
-- Respuesta: No cambia automáticamente hasta ejecutar REFRESH MATERIALIZED VIEW.
SELECT * FROM mv_ventas_por_mes;

-- Refrescar y consultar otra vez
REFRESH MATERIALIZED VIEW mv_ventas_por_mes;
SELECT * FROM mv_ventas_por_mes;


-- Ejercicio 5: Listar índices existentes con pg_indexes
SELECT
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- ¿Qué columnas ya tienen índice y por qué?
-- Respuesta: Principalmente las columnas de clave primaria (PRIMARY KEY) y, si están definidas,
-- restricciones UNIQUE. PostgreSQL crea automáticamente un índice B-tree para garantizar
-- unicidad y acelerar búsquedas por identificador único.


-- Ejercicio 6: Prueba de rendimiento con 1 millón de filas en prueba_indices
CREATE TABLE prueba_indices (
    id SERIAL,
    cliente_id INT,
    fecha TIMESTAMP,
    total NUMERIC(12, 2)
);

INSERT INTO prueba_indices (cliente_id, fecha, total)
SELECT
    (floor(random() * 10000) + 1)::INT,
    NOW() - (random() * interval '365 days'),
    round((random() * 50000 + 100)::NUMERIC, 2)
FROM generate_series(1, 1000000);

-- EXPLAIN ANALYZE antes del índice
EXPLAIN ANALYZE
SELECT *
FROM prueba_indices
WHERE cliente_id = 42;

-- Crear índice y volver a ejecutar EXPLAIN ANALYZE
CREATE INDEX idx_prueba_indices_cliente_id ON prueba_indices (cliente_id);

EXPLAIN ANALYZE
SELECT *
FROM prueba_indices
WHERE cliente_id = 42;

-- Anotar aquí los resultados obtenidos al ejecutar:
-- Sin índice: Scan type = [Seq Scan / Parallel Seq Scan], Execution Time = [completar ms]
-- Con índice: Scan type = [Index Scan / Bitmap Index Scan], Execution Time = [completar ms]

DROP TABLE prueba_indices;


-- Ejercicio 7: Crear índices en minimercado y verificar con pg_indexes
CREATE INDEX IF NOT EXISTS idx_ventas_cliente_id ON ventas (cliente_id);
CREATE INDEX IF NOT EXISTS idx_venta_productos_producto_id ON venta_productos (producto_id);
CREATE INDEX IF NOT EXISTS idx_ventas_fecha ON ventas (fecha);

SELECT
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename IN ('ventas', 'venta_productos')
ORDER BY tablename, indexname;


-- Ejercicio 8: Función fn_total_gastado(p_cliente_id INT)
CREATE OR REPLACE FUNCTION fn_total_gastado(p_cliente_id INT)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_total NUMERIC;
BEGIN
    SELECT COALESCE(SUM(vp.cantidad * vp.precio_unitario), 0)
    INTO v_total
    FROM ventas v
    JOIN venta_productos vp ON v.id = vp.venta_id
    WHERE v.cliente_id = p_cliente_id;

    RETURN v_total;
END;
$$;

SELECT
    c.id,
    c.nombre,
    fn_total_gastado(c.id) AS total_gastado
FROM clientes c
ORDER BY total_gastado DESC;


-- Ejercicio 9: Procedimiento sp_aumentar_precios
CREATE OR REPLACE PROCEDURE sp_aumentar_precios(
    p_proveedor_id INT,
    p_porcentaje NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_filas_actualizadas INT;
BEGIN
    UPDATE productos
    SET precio = precio * (1 + (p_porcentaje / 100.0))
    WHERE proveedor_id = p_proveedor_id;

    GET DIAGNOSTICS v_filas_actualizadas = ROW_COUNT;
    RAISE NOTICE 'Productos actualizados: %', v_filas_actualizadas;
END;
$$;

-- Precios antes (Lácteos del Valle)
SELECT p.id, p.nombre, p.precio
FROM productos p
JOIN proveedores pr ON p.proveedor_id = pr.id
WHERE pr.nombre = 'Lácteos del Valle';

-- Ejecutar procedimiento (+10%)
CALL sp_aumentar_precios(
    (SELECT id FROM proveedores WHERE nombre = 'Lácteos del Valle' LIMIT 1),
    10
);

-- Precios después
SELECT p.id, p.nombre, p.precio
FROM productos p
JOIN proveedores pr ON p.proveedor_id = pr.id
WHERE pr.nombre = 'Lácteos del Valle';


-- Ejercicio 10: Trigger trg_descontar_stock
CREATE OR REPLACE FUNCTION fn_trg_descontar_stock()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE productos
    SET stock = stock - NEW.cantidad
    WHERE id = NEW.producto_id;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_descontar_stock
AFTER INSERT ON venta_productos
FOR EACH ROW
EXECUTE FUNCTION fn_trg_descontar_stock();

-- Stock antes de agregar Leche Entera
SELECT id, nombre, stock FROM productos WHERE nombre = 'Leche Entera';

-- Crear venta nueva con RETURNING id e insertar Leche Entera (ej. cantidad 1)
WITH nueva_venta AS (
    INSERT INTO ventas (cliente_id, fecha)
    VALUES (1, CURRENT_TIMESTAMP)
    RETURNING id
)
INSERT INTO venta_productos (venta_id, producto_id, cantidad, precio_unitario)
SELECT
    nv.id,
    p.id,
    1,
    p.precio
FROM nueva_venta nv
CROSS JOIN productos p
WHERE p.nombre = 'Leche Entera';

-- Stock después
SELECT id, nombre, stock FROM productos WHERE nombre = 'Leche Entera';


-- Ejercicio 11: Intentar agregar Jamón Cocido (stock 0)
-- Nota: Si existe o agregás una restricción CHECK (stock >= 0) en productos,
-- el UPDATE del trigger fallará y revertirá la transacción (rollback).
-- Si no hay CHECK (stock >= 0), stock pasará a negativo salvo que el trigger
-- valide stock suficiente y lance RAISE EXCEPTION.
SELECT id, nombre, stock FROM productos WHERE nombre = 'Jamón Cocido';

-- Si querés validar que no quede stock negativo en el trigger (opcional según consigna):
-- IF (SELECT stock FROM productos WHERE id = NEW.producto_id) < 0 THEN
--     RAISE EXCEPTION 'Stock insuficiente para el producto %', NEW.producto_id;
-- END IF;

-- Explicación (anotar como comentario final):
-- Si la base tiene restricción CHECK (stock >= 0) o el trigger lanza EXCEPTION al quedar stock < 0,
-- PostgreSQL aborta la sentencia y NO se guarda la fila en venta_productos.
-- Si no existe restricción ni validación en el trigger, el INSERT en venta_productos sí se guarda
-- y el stock queda en negativo (-cantidad).
