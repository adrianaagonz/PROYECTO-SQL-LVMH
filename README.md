# Proyecto SQL: Grupo LVMH

Módulo SQL - Máster en Data Science e IA 

---

## ¿De qué va este proyecto?

He construido una base de datos relacional ficticia que simula cómo podría funcionar el sistema de ventas del grupo LVMH — Louis Vuitton, Dior, Fendi, Sephora, Moët & Chandon, entre otras.

Elegí LVMH porque es un sector que conozco bien. Estudié en París con una beca Erasmus en ESCE Business School y obtuve una certificación LVMH en branding y experiencia de cliente. Me pareció más interesante trabajar con un modelo de negocio que entiendo de verdad que con datos genéricos.

El objetivo del proyecto es diseñar un modelo de datos coherente, cargarlo con datos ficticios pero realistas, y extraer conclusiones de negocio usando SQL.

---

## Archivos

```
01_schema.sql   → Creación de tablas, relaciones, índices, vistas y función
02_data.sql     → Inserción de datos, correcciones y limpieza
03_eda.sql      → Análisis exploratorio e insights de negocio
README.md       → Este archivo
```

---

## El modelo de datos

Sigue una arquitectura de estrella (star schema): una tabla central de hechos rodeada de dimensiones.

**Tabla de hechos:** `ventas`
Cada fila es una venta — un producto comprado por un cliente en una tienda en una fecha concreta.

**Dimensiones:**

| Tabla | Qué representa |
|---|---|
| `marcas` | Las marcas del grupo: LV, Dior, Fendi, Sephora... |
| `productos` | El catálogo de referencias por marca y categoría |
| `clientes` | 25 clientes ficticios de distintos países y segmentos |
| `tiendas` | Flagships, outlets y tienda online en ciudades reales |
| `calendario` | Fechas enriquecidas con mes, trimestre, temporada SS/FW |

---

## Decisiones de diseño

**PKs:** uso claves surrogadas (`INT AUTO_INCREMENT`) en todas las tablas para que el identificador no dependa de los datos de negocio.

**FKs:** la tabla `ventas` referencia las cuatro dimensiones. `ON DELETE RESTRICT` impide borrar una marca que tenga productos asociados. `ON UPDATE CASCADE` propaga cambios automáticamente.

**Constraints CHECK:** controlan que los valores sean válidos — por ejemplo, `precio_base > 0`, o que `segmento` solo pueda ser VIP, Estándar o Nuevo. Funcionan como una validación automática dentro de la propia base de datos.

**id_fecha como INT:** la fecha se guarda en formato `YYYYMMDD` (ej: `20240315`) porque los números se comparan más rápido que los tipos DATE en los JOINs.

**Alcance:**
- Incluye ventas de productos en tiendas propias y online, años 2023 y 2024
- No incluye devoluciones, stock, proveedores ni datos financieros reales

---

## Qué técnicas SQL cubre

CTEs encadenadas, funciones ventana con `OVER PARTITION BY`, transacciones con `BEGIN/COMMIT/ROLLBACK`, subqueries, `INNER JOIN` y `LEFT JOIN`, `CASE`, `CAST`, agregaciones, índices, vistas y una función propia `calcular_total()`.

---

## Los 3 insights principales

**1. Louis Vuitton y Dior lideran los ingresos del grupo**
La división de Moda y Marroquinería concentra la mayor parte de los ingresos, muy por encima de Vinos, Joyería o Cosméticos.

**2. El segmento VIP es pequeño pero mueve la mayor parte del dinero**
Aunque son minoría, los clientes VIP tienen un ticket medio muy superior al resto. En lujo, la estrategia tiene que enfocarse en retener al cliente de alto valor.

**3. El Q4 es el trimestre más fuerte**
Las ventas se disparan en el último trimestre del año, impulsadas por Navidad y la temporada FW. Es un patrón consistente con el comportamiento real del sector.

---

## Cómo ejecutarlo

Necesitas MySQL 8+ y MySQL Workbench. Ejecuta los archivos en orden:

```
01_schema.sql → 02_data.sql → 03_eda.sql
```

El proyecto se construye desde cero automáticamente con `DROP DATABASE IF EXISTS lvmh` al inicio.

> Nota: el error que aparece en el Bloque 5 del `03_eda.sql` es intencionado. Demuestro que el constraint `chk_precio` bloquea un precio incorrecto y que el `ROLLBACK` revierte la operación sin afectar a los datos.

---


