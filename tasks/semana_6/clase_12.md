# Semana 6 • Clase 12 — JOINs sobre el minimercado

## 1. Listado de ventas con información de clientes (INNER JOIN)
Permite obtener todas las transacciones realizadas asociadas al nombre del cliente que las efectuó.

```sql
SELECT 
    v.id_venta,
    v.fecha,
    c.nombre AS cliente_nombre,
    c.apellido AS cliente_apellido,
    v.total
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente;
SELECT 
    dv.id_venta,
    p.nombre_producto,
    dv.cantidad,
    dv.precio_unitario,
    (dv.cantidad * dv.precio_unitario) AS subtotal
FROM detalle_ventas dv
INNER JOIN productos p ON dv.id_producto = p.id_producto;
SELECT 
    dv.id_venta,
    p.nombre_producto,
    dv.cantidad,
    dv.precio_unitario,
    (dv.cantidad * dv.precio_unitario) AS subtotal
FROM detalle_ventas dv
INNER JOIN productos p ON dv.id_producto = p.id_producto;
SELECT 
    c.id_cliente,
    c.nombre,
    c.apellido,
    v.id_venta,
    v.fecha
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente;
