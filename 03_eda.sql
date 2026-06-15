-- ============================================================
-- 03_eda.sql — Análisis Exploratorio y Consultas de Negocio
-- Proyecto: Grupo LVMH
-- Descripción: Limpieza de datos, análisis descriptivo e
--              insights de negocio mediante SQL avanzado.
-- ============================================================

USE lvmh;


-- ============================================================
-- BLOQUE 1: CALIDAD DE DATOS
-- ============================================================

-- 1.1 Detectar valores NULL en tablas principales
-- Insight: identificar campos sin rellenar que podrían afectar al análisis

SELECT 'clientes' AS tabla, COUNT(*) AS registros_con_null
FROM clientes
WHERE nombre IS NULL OR apellido IS NULL OR email IS NULL OR pais IS NULL

UNION ALL

SELECT 'productos', COUNT(*)
FROM productos
WHERE nombre IS NULL OR categoria IS NULL OR precio_base IS NULL

UNION ALL

SELECT 'ventas', COUNT(*)
FROM ventas
WHERE id_cliente IS NULL OR id_producto IS NULL OR total IS NULL;


-- 1.2 Detectar clientes duplicados por email
-- Un email debería ser único; si aparece más de una vez hay duplicado

SELECT email, COUNT(*) AS veces
FROM clientes
GROUP BY email
HAVING COUNT(*) > 1;


-- 1.3 Detectar ventas duplicadas (mismo cliente, producto, tienda y fecha)
-- Usamos RANK() con PARTITION BY para identificarlos

SELECT *
FROM (
    SELECT
        id_venta,
        id_cliente,
        id_producto,
        id_tienda,
        id_fecha,
        RANK() OVER (
            PARTITION BY id_cliente, id_producto, id_tienda, id_fecha
            ORDER BY id_venta
        ) AS rk
    FROM ventas
) ranked
WHERE rk > 1;
-- Si aparecen filas, son duplicados. El rk=1 es el original.


-- 1.4 Detectar precios fuera de rango esperado (outliers)
-- Un precio negativo o cero sería un error de datos

SELECT id_producto, nombre, precio_base
FROM productos
WHERE precio_base <= 0;

-- También comprobamos totales negativos en ventas (no debería haberlos)
SELECT id_venta, total
FROM ventas
WHERE total <= 0;


-- 1.5 Detectar fechas con tipo incorrecto
-- Verificamos que todas las fechas en calendario son válidas
-- CAST para asegurar que se puede convertir a DATE

SELECT id_fecha, fecha,
       CAST(fecha AS DATE) AS fecha_convertida
FROM calendario
WHERE CAST(fecha AS DATE) IS NULL;
-- Si devuelve filas, hay fechas con formato incorrecto


-- 1.6 Corregir nulos: tiendas sin metros_cuadrados (Online = NULL es correcto,
--     pero si hay otra tienda sin metros, le asignamos un valor por defecto)

UPDATE tiendas
SET metros_cuadrados = 500
WHERE metros_cuadrados IS NULL
  AND tipo != 'Online';
-- La tienda Online queda con NULL intencionalmente (no aplica)


-- ============================================================
-- BLOQUE 2: ANÁLISIS DESCRIPTIVO (EDA)
-- ============================================================

-- 2.1 Resumen general del dataset
-- Insight: visión de conjunto del volumen de datos

SELECT
    (SELECT COUNT(*) FROM ventas)    AS total_ventas,
    (SELECT COUNT(*) FROM clientes)  AS total_clientes,
    (SELECT COUNT(*) FROM productos) AS total_productos,
    (SELECT COUNT(*) FROM tiendas)   AS total_tiendas,
    (SELECT COUNT(*) FROM marcas)    AS total_marcas;


-- 2.2 Estadísticas básicas de ventas
-- Insight: entender la distribución del ticket de venta

SELECT
    COUNT(*)                    AS num_transacciones,
    ROUND(SUM(total), 2)        AS ingresos_totales,
    ROUND(AVG(total), 2)        AS ticket_medio,
    ROUND(MIN(total), 2)        AS venta_minima,
    ROUND(MAX(total), 2)        AS venta_maxima
FROM ventas;


-- 2.3 Distribución de clientes por segmento
-- Insight: qué proporción de nuestra base es VIP vs Estándar vs Nuevo

SELECT
    segmento,
    COUNT(*) AS num_clientes,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM clientes), 1) AS porcentaje
FROM clientes
GROUP BY segmento
ORDER BY num_clientes DESC;


-- 2.4 Productos por categoría
-- Insight: cuántas referencias tenemos por tipo de producto

SELECT
    categoria,
    COUNT(*) AS num_productos,
    ROUND(AVG(precio_base), 2) AS precio_medio
FROM productos
GROUP BY categoria
ORDER BY precio_medio DESC;


-- ============================================================
-- BLOQUE 3: CONSULTAS ANALÍTICAS DE NEGOCIO
-- ============================================================

-- CONSULTA 1: Ingresos totales por marca (ranking)
-- Insight: qué marcas generan más ingresos para el grupo LVMH

SELECT
    m.nombre                    AS marca,
    m.division,
    COUNT(v.id_venta)           AS num_ventas,
    SUM(v.cantidad)             AS unidades_vendidas,
    ROUND(SUM(v.total), 2)      AS ingresos_totales,
    ROUND(AVG(v.total), 2)      AS ticket_medio
FROM ventas v
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN marcas m    ON p.id_marca    = m.id_marca
GROUP BY m.nombre, m.division
ORDER BY ingresos_totales DESC;


-- CONSULTA 2: Ingresos por división del grupo
-- Insight: qué segmento de negocio (Moda, Perfumes, Vinos...) es el más rentable

SELECT
    m.division,
    COUNT(v.id_venta)           AS num_ventas,
    ROUND(SUM(v.total), 2)      AS ingresos_totales,
    ROUND(AVG(v.total), 2)      AS ticket_medio
FROM ventas v
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN marcas m    ON p.id_marca    = m.id_marca
GROUP BY m.division
ORDER BY ingresos_totales DESC;


-- CONSULTA 3: Top 5 productos más vendidos por ingresos
-- Insight: qué referencias específicas generan más dinero

SELECT
    p.nombre                AS producto,
    m.nombre                AS marca,
    p.categoria,
    COUNT(v.id_venta)       AS veces_vendido,
    SUM(v.cantidad)         AS unidades,
    ROUND(SUM(v.total), 2)  AS ingresos
FROM ventas v
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN marcas m    ON p.id_marca    = m.id_marca
GROUP BY p.nombre, m.nombre, p.categoria
ORDER BY ingresos DESC
LIMIT 5;


-- CONSULTA 4: Ventas por país de la tienda
-- Insight: qué mercados geográficos generan más ingresos

SELECT
    t.pais,
    COUNT(v.id_venta)           AS num_ventas,
    ROUND(SUM(v.total), 2)      AS ingresos_totales,
    ROUND(AVG(v.total), 2)      AS ticket_medio
FROM ventas v
LEFT JOIN tiendas t ON v.id_tienda = t.id_tienda
GROUP BY t.pais
ORDER BY ingresos_totales DESC;


-- CONSULTA 5: Comparativa de ingresos 2023 vs 2024
-- Insight: cómo ha evolucionado el negocio año sobre año

SELECT
    cal.anio,
    COUNT(v.id_venta)           AS num_ventas,
    ROUND(SUM(v.total), 2)      AS ingresos_totales,
    ROUND(AVG(v.total), 2)      AS ticket_medio
FROM ventas v
INNER JOIN calendario cal ON v.id_fecha = cal.id_fecha
GROUP BY cal.anio
ORDER BY cal.anio;


-- CONSULTA 6: Ingresos por trimestre (estacionalidad)
-- Insight: en qué época del año vende más el grupo

SELECT
    cal.anio,
    cal.trimestre,
    ROUND(SUM(v.total), 2)      AS ingresos_totales,
    COUNT(v.id_venta)           AS num_ventas
FROM ventas v
INNER JOIN calendario cal ON v.id_fecha = cal.id_fecha
GROUP BY cal.anio, cal.trimestre
ORDER BY cal.anio, cal.trimestre;


-- CONSULTA 7: Análisis por segmento de cliente
-- Insight: los clientes VIP generan cuántas veces más que los Estándar

SELECT
    cl.segmento,
    COUNT(DISTINCT cl.id_cliente)   AS num_clientes,
    COUNT(v.id_venta)               AS num_compras,
    ROUND(SUM(v.total), 2)          AS ingresos_totales,
    ROUND(AVG(v.total), 2)          AS ticket_medio,
    ROUND(SUM(v.total) / COUNT(DISTINCT cl.id_cliente), 2) AS gasto_medio_por_cliente
FROM clientes cl
LEFT JOIN ventas v ON cl.id_cliente = v.id_cliente
GROUP BY cl.segmento
ORDER BY ingresos_totales DESC;


-- CONSULTA 8: Clientes top 5 por gasto total
-- Insight: identificar los mejores clientes del grupo

SELECT
    cl.nombre,
    cl.apellido,
    cl.pais,
    cl.segmento,
    COUNT(v.id_venta)           AS num_compras,
    ROUND(SUM(v.total), 2)      AS gasto_total
FROM clientes cl
INNER JOIN ventas v ON cl.id_cliente = v.id_cliente
GROUP BY cl.id_cliente, cl.nombre, cl.apellido, cl.pais, cl.segmento
ORDER BY gasto_total DESC
LIMIT 5;


-- CONSULTA 9: Rendimiento por tipo de tienda (Flagship vs Online vs Outlet)
-- Insight: el canal de venta online vs físico

SELECT
    t.tipo,
    COUNT(v.id_venta)           AS num_ventas,
    ROUND(SUM(v.total), 2)      AS ingresos_totales,
    ROUND(AVG(v.total), 2)      AS ticket_medio
FROM ventas v
LEFT JOIN tiendas t ON v.id_tienda = t.id_tienda
GROUP BY t.tipo
ORDER BY ingresos_totales DESC;


-- CONSULTA 10: Ranking de marcas por trimestre usando CTE encadenada
-- Insight: qué marca lidera en cada trimestre del año
-- Usamos CTEs encadenadas (WITH ... AS)

WITH ventas_enriquecidas AS (
    -- CTE 1: unimos ventas con calendario y productos
    SELECT
        v.id_venta,
        v.total,
        cal.anio,
        cal.trimestre,
        p.id_marca
    FROM ventas v
    INNER JOIN calendario cal ON v.id_fecha    = cal.id_fecha
    INNER JOIN productos   p  ON v.id_producto = p.id_producto
),
ventas_por_marca_trimestre AS (
    -- CTE 2: agregamos por marca y trimestre
    SELECT
        ve.anio,
        ve.trimestre,
        m.nombre                    AS marca,
        ROUND(SUM(ve.total), 2)     AS ingresos
    FROM ventas_enriquecidas ve
    INNER JOIN marcas m ON ve.id_marca = m.id_marca
    GROUP BY ve.anio, ve.trimestre, m.nombre
),
ranking AS (
    -- CTE 3: aplicamos función ventana para rankear
    SELECT
        anio,
        trimestre,
        marca,
        ingresos,
        RANK() OVER (PARTITION BY anio, trimestre ORDER BY ingresos DESC) AS posicion
    FROM ventas_por_marca_trimestre
)
-- Resultado final: top 3 marcas por trimestre
SELECT anio, trimestre, posicion, marca, ingresos
FROM ranking
WHERE posicion <= 3
ORDER BY anio, trimestre, posicion;


-- CONSULTA 11: Función ventana — acumulado de ingresos por marca en el tiempo
-- Insight: cómo crece el ingreso acumulado de cada marca mes a mes

SELECT
    m.nombre                                AS marca,
    cal.anio,
    cal.mes,
    cal.nombre_mes,
    ROUND(SUM(v.total), 2)                  AS ingresos_mes,
    ROUND(SUM(SUM(v.total)) OVER (
        PARTITION BY m.nombre, cal.anio
        ORDER BY cal.mes
    ), 2)                                   AS ingresos_acumulados
FROM ventas v
INNER JOIN productos  p   ON v.id_producto = p.id_producto
INNER JOIN marcas     m   ON p.id_marca    = m.id_marca
INNER JOIN calendario cal ON v.id_fecha    = cal.id_fecha
GROUP BY m.nombre, cal.anio, cal.mes, cal.nombre_mes
ORDER BY m.nombre, cal.anio, cal.mes;


-- CONSULTA 12: Clasificación de ventas con CASE
-- Insight: categorizar cada venta según su importe para detectar
--          qué proporción son ventas de alto valor vs bajo valor

SELECT
    CASE
        WHEN total >= 3000  THEN 'Alta gama (≥3.000€)'
        WHEN total >= 500   THEN 'Media gama (500-2.999€)'
        WHEN total >= 100   THEN 'Acceso (100-499€)'
        ELSE                     'Bajo ticket (<100€)'
    END AS rango_precio,
    COUNT(*)                    AS num_ventas,
    ROUND(SUM(total), 2)        AS ingresos_totales,
    ROUND(AVG(total), 2)        AS ticket_medio
FROM ventas
GROUP BY rango_precio
ORDER BY ingresos_totales DESC;


-- ============================================================
-- BLOQUE 4: USO DE VISTAS CREADAS EN EL SCHEMA
-- ============================================================

-- Consulta sobre v_ventas_detalle (vista completa)
-- Insight: ventas de clientes VIP en tiendas Flagship

SELECT
    marca_nombre,
    producto_nombre,
    cliente_nombre,
    cliente_pais,
    tienda_ciudad,
    total
FROM v_ventas_detalle
WHERE cliente_segmento = 'VIP'
  AND tienda_tipo = 'Flagship'
ORDER BY total DESC
LIMIT 10;


-- Consulta sobre v_ventas_por_marca_mes (vista de KPIs mensuales)
-- Insight: meses con más ingresos en Louis Vuitton

SELECT *
FROM v_ventas_por_marca_mes
WHERE marca = 'Louis Vuitton'
ORDER BY ingresos_totales DESC;


-- ============================================================
-- BLOQUE 5: TRANSACCIÓN CON ROLLBACK DE EJEMPLO
-- ============================================================

-- Simulamos una actualización errónea y la revertimos con ROLLBACK
-- Esto demuestra el uso de transacciones para proteger los datos

START TRANSACTION;

-- Actualizamos por error el precio de todos los productos a 0
UPDATE productos SET precio_base = 0;

-- Nos damos cuenta del error → hacemos ROLLBACK
ROLLBACK;

-- Verificamos que los datos siguen intactos
SELECT id_producto, nombre, precio_base FROM productos LIMIT 5;


-- ============================================================
-- BLOQUE 6: SUBQUERY — productos que nunca se han vendido
-- ============================================================
-- Insight: referencias del catálogo sin ninguna venta registrada

SELECT
    p.id_producto,
    p.nombre,
    m.nombre AS marca,
    p.categoria,
    p.precio_base
FROM productos p
INNER JOIN marcas m ON p.id_marca = m.id_marca
WHERE p.id_producto NOT IN (
    SELECT DISTINCT id_producto FROM ventas
);
