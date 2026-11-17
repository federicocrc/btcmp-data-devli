# Semana 6 • Clase 11 — Diseño de una base de datos transaccional

## 1. Descripción del Sistema
Diseño de un modelo relacional transaccional (OLTP) optimizado para garantizar la integridad de los datos (ACID), evitando redundancias y asegurando la normalización hasta la Tercera Forma Normal (3FN).

## 2. Modelo Entidad-Relación (Tablas y Relaciones)

### Tabla: `usuarios`
Almacena la información de los clientes registrados.
- `id` (INT, PK)
- `nombre` (VARCHAR)
- `email` (VARCHAR, UNIQUE)
- `fecha_registro` (TIMESTAMP)

### Tabla: `productos`
Almacena el catálogo de productos disponibles.
- `id` (INT, PK)
- `nombre` (VARCHAR)
- `precio` (DECIMAL)
- `stock` (INT)

### Tabla: `ordenes`
Registra las transacciones de compra realizadas por los usuarios.
- `id` (INT, PK)
- `usuario_id` (INT, FK -> usuarios.id)
- `fecha_orden` (TIMESTAMP)
- `estado` (VARCHAR) -- Ejemplo: Pendiente, Completada, Cancelada

### Tabla: `detalle_ordenes`
Tabla intermedia para resolver la relación muchos a muchos entre órdenes y productos.
- `id` (INT, PK)
- `orden_id` (INT, FK -> ordenes.id)
- `producto_id` (INT, FK -> productos.id)
- `cantidad` (INT)
- `precio_unitario` (DECIMAL)
