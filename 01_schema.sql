-- ============================================================
-- PROYECTO SQL: GRUPO LVMH - Modelo de Ventas
-- Motor: MySQL 8+
-- Autora: Adriana
-- Descripción: Base de datos relacional ficticia que modela
--              las ventas del grupo LVMH por marca, producto,
--              tienda y cliente a nivel global.
-- ============================================================

-- Ejecutar desde cero de forma segura
DROP DATABASE IF EXISTS lvmh;
CREATE DATABASE lvmh CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE lvmh;


-- ============================================================
-- DIMENSIÓN 1: marcas
-- Representa cada marca del grupo LVMH
-- Granularidad: 1 fila = 1 marca
-- PK: id_marca (surrogate key, autoincremental)
-- ============================================================
CREATE TABLE marcas (
    id_marca      INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(100) NOT NULL UNIQUE,         -- Nombre único de la marca
    division      VARCHAR(50)  NOT NULL,                -- División dentro de LVMH
    pais_origen   VARCHAR(50)  NOT NULL DEFAULT 'Francia',
    anio_fundacion INT,
    activa        TINYINT(1)   NOT NULL DEFAULT 1,      -- 1 = activa, 0 = inactiva
    -- CHECK para división válida
    CONSTRAINT chk_division CHECK (division IN (
        'Moda y Marroquinería',
        'Perfumes y Cosméticos',
        'Vinos y Destilados',
        'Relojes y Joyería',
        'Distribución Selectiva'
    ))
);


-- ============================================================
-- DIMENSIÓN 2: productos
-- Catálogo de productos por marca y categoría
-- Granularidad: 1 fila = 1 referencia de producto
-- PK: id_producto
-- FK: id_marca → marcas
-- ============================================================
CREATE TABLE productos (
    id_producto   INT AUTO_INCREMENT PRIMARY KEY,
    id_marca      INT          NOT NULL,
    nombre        VARCHAR(150) NOT NULL,
    categoria     VARCHAR(50)  NOT NULL,                -- Categoría del producto
    precio_base   DECIMAL(10,2) NOT NULL,
    -- Precio siempre positivo
    CONSTRAINT chk_precio CHECK (precio_base > 0),
    CONSTRAINT chk_categoria CHECK (categoria IN (
        'Bolsos', 'Ropa', 'Calzado', 'Accesorios',
        'Perfume', 'Cosmética', 'Vino', 'Champán', 'Destilado',
        'Reloj', 'Joyería', 'Maquillaje'
    )),
    CONSTRAINT fk_producto_marca FOREIGN KEY (id_marca)
        REFERENCES marcas(id_marca)
        ON DELETE RESTRICT       -- No eliminar marca si tiene productos
        ON UPDATE CASCADE
);


-- ============================================================
-- DIMENSIÓN 3: clientes
-- Clientes ficticios del grupo
-- Granularidad: 1 fila = 1 cliente
-- PK: id_cliente
-- ============================================================
CREATE TABLE clientes (
    id_cliente    INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(100) NOT NULL,
    apellido      VARCHAR(100) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    pais          VARCHAR(50)  NOT NULL,
    segmento      VARCHAR(20)  NOT NULL DEFAULT 'Estándar',
    fecha_registro DATE         NOT NULL,
    -- Segmento controlado
    CONSTRAINT chk_segmento CHECK (segmento IN ('VIP', 'Estándar', 'Nuevo'))
);


-- ============================================================
-- DIMENSIÓN 4: tiendas
-- Puntos de venta físicos y online del grupo
-- Granularidad: 1 fila = 1 tienda
-- PK: id_tienda
-- ============================================================
CREATE TABLE tiendas (
    id_tienda     INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(150) NOT NULL,
    ciudad        VARCHAR(100) NOT NULL,
    pais          VARCHAR(50)  NOT NULL,
    tipo          VARCHAR(20)  NOT NULL DEFAULT 'Flagship',
    metros_cuadrados INT,
    -- Tipo de tienda controlado
    CONSTRAINT chk_tipo_tienda CHECK (tipo IN ('Flagship', 'Outlet', 'Online', 'Duty Free', 'Pop-up'))
);


-- ============================================================
-- DIMENSIÓN 5: calendario
-- Tabla de fechas para análisis temporal
-- Granularidad: 1 fila = 1 día
-- PK: id_fecha (formato YYYYMMDD para joins rápidos)
-- ============================================================
CREATE TABLE calendario (
    id_fecha      INT PRIMARY KEY,                      -- Ej: 20240315
    fecha         DATE         NOT NULL UNIQUE,
    anio          INT          NOT NULL,
    trimestre     TINYINT      NOT NULL,
    mes           TINYINT      NOT NULL,
    nombre_mes    VARCHAR(20)  NOT NULL,
    semana        TINYINT      NOT NULL,
    dia_semana    VARCHAR(15)  NOT NULL,
    es_fin_semana TINYINT(1)   NOT NULL DEFAULT 0,
    temporada     VARCHAR(20)  NOT NULL,                -- SS / FW / etc.
    CONSTRAINT chk_trimestre CHECK (trimestre BETWEEN 1 AND 4),
    CONSTRAINT chk_mes CHECK (mes BETWEEN 1 AND 12)
);


-- ============================================================
-- TABLA DE HECHOS: ventas
-- Cada fila = una línea de venta (1 producto en 1 transacción)
-- PK: id_venta
-- FKs: todas las dimensiones
-- ============================================================
CREATE TABLE ventas (
    id_venta        INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente      INT            NOT NULL,
    id_producto     INT            NOT NULL,
    id_tienda       INT            NOT NULL,
    id_fecha        INT            NOT NULL,
    cantidad        INT            NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2)  NOT NULL,            -- Precio real de venta (puede diferir del precio_base)
    descuento       DECIMAL(5,2)   NOT NULL DEFAULT 0.00, -- % de descuento aplicado
    total           DECIMAL(10,2)  NOT NULL,            -- cantidad * precio_unitario * (1 - descuento/100)

    -- Constraints de integridad
    CONSTRAINT chk_cantidad   CHECK (cantidad > 0),
    CONSTRAINT chk_descuento  CHECK (descuento BETWEEN 0 AND 100),
    CONSTRAINT chk_total      CHECK (total > 0),

    -- Foreign Keys
    CONSTRAINT fk_venta_cliente  FOREIGN KEY (id_cliente)  REFERENCES clientes(id_cliente)   ON UPDATE CASCADE,
    CONSTRAINT fk_venta_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON UPDATE CASCADE,
    CONSTRAINT fk_venta_tienda   FOREIGN KEY (id_tienda)   REFERENCES tiendas(id_tienda)     ON UPDATE CASCADE,
    CONSTRAINT fk_venta_fecha    FOREIGN KEY (id_fecha)    REFERENCES calendario(id_fecha)   ON UPDATE CASCADE
);


-- ============================================================
-- ÍNDICES
-- Se añaden en columnas usadas frecuentemente en WHERE y JOIN
-- ============================================================

-- Índice en ventas por fecha → acelera consultas de series temporales
CREATE INDEX idx_ventas_fecha ON ventas(id_fecha);

-- Índice en ventas por cliente → acelera análisis por segmento
CREATE INDEX idx_ventas_cliente ON ventas(id_cliente);

-- Índice en productos por marca → acelera filtros por marca
CREATE INDEX idx_productos_marca ON productos(id_marca);

-- ============================================================
-- VISTAS DE NEGOCIO
-- ============================================================

-- Vista 1: ventas enriquecidas con todas las dimensiones
-- Útil para hacer cualquier consulta sin tener que repetir JOINs
CREATE OR REPLACE VIEW v_ventas_detalle AS
SELECT
    v.id_venta,
    c.id_fecha,
    cal.fecha,
    cal.anio,
    cal.nombre_mes,
    cal.trimestre,
    cal.temporada,
    cl.nombre        AS cliente_nombre,
    cl.apellido      AS cliente_apellido,
    cl.pais          AS cliente_pais,
    cl.segmento      AS cliente_segmento,
    p.nombre         AS producto_nombre,
    p.categoria      AS producto_categoria,
    m.nombre         AS marca_nombre,
    m.division       AS marca_division,
    t.nombre         AS tienda_nombre,
    t.ciudad         AS tienda_ciudad,
    t.pais           AS tienda_pais,
    t.tipo           AS tienda_tipo,
    v.cantidad,
    v.precio_unitario,
    v.descuento,
    v.total
FROM ventas v
JOIN clientes  cl  ON v.id_cliente  = cl.id_cliente
JOIN productos p   ON v.id_producto = p.id_producto
JOIN marcas    m   ON p.id_marca    = m.id_marca
JOIN tiendas   t   ON v.id_tienda   = t.id_tienda
JOIN calendario cal ON v.id_fecha   = cal.id_fecha;


-- Vista 2: resumen de ventas por marca y mes
-- KPI rápido de rendimiento mensual por marca
CREATE OR REPLACE VIEW v_ventas_por_marca_mes AS
SELECT
    m.nombre              AS marca,
    m.division,
    cal.anio,
    cal.nombre_mes,
    cal.mes,
    COUNT(v.id_venta)     AS num_ventas,
    SUM(v.cantidad)       AS unidades_vendidas,
    ROUND(SUM(v.total), 2)        AS ingresos_totales,
    ROUND(AVG(v.total), 2)        AS ticket_medio
FROM ventas v
JOIN productos p   ON v.id_producto = p.id_producto
JOIN marcas    m   ON p.id_marca    = m.id_marca
JOIN calendario cal ON v.id_fecha   = cal.id_fecha
GROUP BY m.nombre, m.division, cal.anio, cal.nombre_mes, cal.mes
ORDER BY cal.anio, cal.mes, ingresos_totales DESC;


-- ============================================================
-- FUNCIÓN: calcular_total
-- Calcula el total de una venta dado precio, cantidad y descuento
-- Útil para validar o recalcular el campo total
-- ============================================================
DELIMITER $$

CREATE FUNCTION calcular_total(
    p_precio    DECIMAL(10,2),
    p_cantidad  INT,
    p_descuento DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN ROUND(p_precio * p_cantidad * (1 - p_descuento / 100), 2);
END$$

DELIMITER ;
