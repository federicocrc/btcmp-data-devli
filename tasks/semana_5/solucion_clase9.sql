-- =====================================================================
-- PARTE 1: Tabla de departamentos en venta/alquiler y ejercicios
-- =====================================================================

CREATE DATABASE test_db;


CREATE TABLE apartments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    address VARCHAR(100),
    city VARCHAR(50),
    postal_code VARCHAR(10),
    bedrooms INT,
    area_m2 NUMERIC(6,2),
    price NUMERIC(10,2),
    available BOOLEAN,
    published_date DATE
);

-- Inserción de 30 filas de ejemplo
INSERT INTO apartments (name, address, city, postal_code, bedrooms, area_m2, price, available, published_date) VALUES
('Depto A', 'Av. Siempre Viva 123', 'Buenos Aires', 'C1000', 2, 55.5, 120000, TRUE, '2023-08-01'),
('Depto B', 'Calle Falsa 456', 'Cordoba', 'X5000', 1, 40.0, 85000, TRUE, '2023-08-02'),
('Depto C', 'Belgrano 789', 'Rosario', 'S2000', 3, 80.0, 150000, FALSE, '2023-08-03'),
('Depto D', 'San Martin 321', 'Buenos Aires', 'C1010', 2, 60.0, 130000, TRUE, '2023-08-04'),
('Depto E', 'Rivadavia 654', 'Mendoza', 'M5500', 4, 110.0, 220000, TRUE, '2023-08-05'),
('Depto F', 'Mitre 987', 'Cordoba', 'X5002', 1, 35.0, 75000, FALSE, '2023-08-06'),
('Depto G', 'Urquiza 111', 'Rosario', 'S2002', 2, 58.0, 115000, TRUE, '2023-08-07'),
('Depto H', 'Sarmiento 222', 'Buenos Aires', 'C1020', 3, 85.0, 170000, TRUE, '2023-08-08'),
('Depto I', 'Alvear 333', 'Mendoza', 'M5502', 2, 65.0, 135000, FALSE, '2023-08-09'),
('Depto J', 'Corrientes 444', 'Buenos Aires', 'C1030', 1, 42.0, 90000, TRUE, '2023-08-10'),
('Depto K', 'Pellegrini 555', 'Rosario', 'S2004', 3, 90.0, 190000, TRUE, '2023-08-11'),
('Depto L', 'Colon 666', 'Cordoba', 'X5004', 2, 52.0, 105000, TRUE, '2023-08-12'),
('Depto M', 'San Lorenzo 777', 'Mendoza', 'M5504', 3, 95.0, 205000, FALSE, '2023-08-13'),
('Depto N', 'Avellaneda 888', 'Buenos Aires', 'C1040', 1, 38.0, 80000, TRUE, '2023-08-14'),
('Depto O', 'Balcarce 999', 'Rosario', 'S2006', 4, 120.0, 250000, TRUE, '2023-08-15'),
('Depto P', 'Necochea 101', 'Cordoba', 'X5006', 2, 63.0, 125000, FALSE, '2023-08-16'),
('Depto Q', 'Salta 202', 'Mendoza', 'M5506', 1, 45.0, 95000, TRUE, '2023-08-17'),
('Depto R', 'Jujuy 303', 'Buenos Aires', 'C1050', 3, 78.0, 160000, TRUE, '2023-08-18'),
('Depto S', 'Tucuman 404', 'Rosario', 'S2008', 2, 59.0, 118000, TRUE, '2023-08-19'),
('Depto T', 'Entre Rios 505', 'Cordoba', 'X5008', 4, 105.0, 230000, FALSE, '2023-08-20'),
('Depto U', 'Catamarca 606', 'Mendoza', 'M5508', 2, 67.0, 140000, TRUE, '2023-08-21'),
('Depto V', 'La Rioja 707', 'Buenos Aires', 'C1060', 1, 39.0, 82000, TRUE, '2023-08-22'),
('Depto W', 'San Juan 808', 'Rosario', 'S2010', 3, 88.0, 185000, FALSE, '2023-08-23'),
('Depto X', 'Mendoza 909', 'Cordoba', 'X5010', 2, 56.0, 110000, TRUE, '2023-08-24'),
('Depto Y', 'Chubut 102', 'Mendoza', 'M5510', 4, 115.0, 240000, TRUE, '2023-08-25'),
('Depto Z', 'Santa Cruz 203', 'Buenos Aires', 'C1070', 1, 41.0, 88000, TRUE, '2023-08-26'),
('Depto AA', 'Chaco 304', 'Rosario', 'S2012', 3, 82.0, 175000, TRUE, '2023-08-27'),
('Depto AB', 'Formosa 405', 'Cordoba', 'X5012', 2, 61.0, 122000, FALSE, '2023-08-28'),
('Depto AC', 'Misiones 506', 'Mendoza', 'M5512', 3, 91.0, 195000, TRUE, '2023-08-29'),
('Depto AD', 'Corrientes 607', 'Buenos Aires', 'C1080', 2, 57.0, 112000, TRUE, '2023-08-30');

-- Ejercicios Parte 1
-- 1. Mostrar los departamentos disponibles, ordenados del más barato al más caro.
SELECT * FROM apartments WHERE available = TRUE ORDER BY price ASC;

-- 2. Mostrar el precio promedio por ciudad.
SELECT city, AVG(price) AS average_price FROM apartments GROUP BY city;

-- 3. Mostrar los departamentos con 2 o más habitaciones y menos de 60 m².
SELECT * FROM apartments WHERE bedrooms >= 2 AND area_m2 < 60.0;


-- =====================================================================
-- PARTE 2: Ventas y ejercicios
-- =====================================================================

CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    product VARCHAR(50),
    category VARCHAR(30),
    price NUMERIC,
    quantity INT,
    sale_date DATE
);

INSERT INTO sales (product, category, price, quantity, sale_date) VALUES
('Mouse', 'Electronics', 15, 4, '2023-07-10'),
('Keyboard', 'Electronics', 30, 2, '2023-07-11'),
('Notebook', 'Stationery', 8, 10, '2023-07-12'),
('Pen', 'Stationery', 2, 25, '2023-07-13'),
('Headphones', 'Electronics', 40, 3, '2023-07-14'),
('Monitor', 'Electronics', 120, 1, '2023-07-15'),
('Desk Chair', 'Furniture', 85, 2, '2023-07-16'),
('Notebook Case', 'Accessories', 25, 3, '2023-07-17'),
('Printer Paper', 'Stationery', 6, 15, '2023-07-18'),
('Smartphone', 'Electronics', 300, 1, '2023-07-30'),
('Notebook Pro', 'Electronics', 900, 1, '2023-07-31'),
('File Cabinet', 'Furniture', 120, 1, '2023-08-01'),
('Backpack', 'Accessories', 40, 3, '2023-08-02'),
('Binder', 'Stationery', 4, 20, '2023-08-03'),
('Headset Stand', 'Accessories', 15, 5, '2023-08-04'),
('Desk Organizer', 'Accessories', 12, 6, '2023-08-05'),
('Laptop Sleeve', 'Accessories', 30, 2, '2023-08-06'),
('Paper Clips', 'Stationery', 1, 50, '2023-08-07'),
('Surge Protector', 'Electronics', 25, 3, '2023-08-08'),
('Pen Holder', 'Accessories', 5, 10, '2023-08-09');

-- Ejercicios Parte 2
-- 1. Mostrar todas las ventas de la categoría 'Electronics'.
SELECT * FROM sales WHERE category = 'Electronics';

-- 2. Calcular el total de ingresos por categoría (price * quantity).
SELECT category, SUM(price * quantity) AS total_revenue FROM sales GROUP BY category;

-- 3. Obtener la categoría con mayor ingreso total.
SELECT category FROM sales GROUP BY category ORDER BY SUM(price * quantity) DESC LIMIT 1;

-- 4. Mostrar todas las ventas donde el precio del producto sea mayor a 20.
SELECT * FROM sales WHERE price > 20;

-- 5. Calcular el total de unidades vendidas (SUM(quantity)) por cada producto.
SELECT product, SUM(quantity) AS total_units FROM sales GROUP BY product;

-- 6. Calcular el ingreso promedio por venta (AVG(price * quantity)) para cada producto.
SELECT product, AVG(price * quantity) AS avg_revenue FROM sales GROUP BY product;

-- 7. Mostrar los 3 productos con mayor cantidad total vendida (SUM(quantity)) usando ORDER BY y LIMIT.
SELECT product, SUM(quantity) AS total_units FROM sales GROUP BY product ORDER BY total_units DESC LIMIT 3;

-- 8. Mostrar todas las ventas realizadas después del 12 de julio de 2023.
SELECT * FROM sales WHERE sale_date > '2023-07-12';

-- 9. Mostrar la categoría y el ingreso total, pero solo para categorías cuyo ingreso sea mayor a 50.
SELECT category, SUM(price * quantity) AS total_revenue FROM sales GROUP BY category HAVING SUM(price * quantity) > 50;

-- 10. Mostrar todas las ventas donde el nombre del producto comience con la letra H.
SELECT * FROM sales WHERE product LIKE 'H%';

-- 11. Calcular la cantidad promedio de productos vendidos (AVG(quantity)) agrupados por categoría.
SELECT category, AVG(quantity) AS avg_quantity FROM sales GROUP BY category;

-- 12. Mostrar todas las ventas y calcular el ingreso por fila (price * quantity), ordenadas de mayor a menor ingreso.
SELECT *, (price * quantity) AS row_revenue FROM sales ORDER BY row_revenue DESC;

-- 13. Mostrar todas las ventas de la categoría 'Electronics' donde la cantidad sea mayor a 2 y el precio menor a 40.
SELECT * FROM sales WHERE category = 'Electronics' AND quantity > 2 AND price < 40;
