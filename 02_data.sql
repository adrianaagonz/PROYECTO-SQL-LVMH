-- ============================================================
-- 02_data.sql — Carga de datos ficticios
-- Proyecto: Grupo LVMH
-- Descripción: INSERT de datos en todas las tablas.
--              Se usa BEGIN/COMMIT para transacciones seguras.
--              Si algo falla, ROLLBACK deshace los cambios.
-- ============================================================

USE lvmh;

-- ============================================================
-- MARCAS del grupo LVMH
-- ============================================================
BEGIN;

INSERT INTO marcas (nombre, division, pais_origen, anio_fundacion, activa) VALUES
('Louis Vuitton',   'Moda y Marroquinería',      'Francia',    1854, 1),
('Dior',            'Moda y Marroquinería',      'Francia',    1946, 1),
('Givenchy',        'Moda y Marroquinería',      'Francia',    1952, 1),
('Fendi',           'Moda y Marroquinería',      'Italia',     1925, 1),
('Sephora',         'Distribución Selectiva',    'Francia',    1969, 1),
('Parfums Givenchy','Perfumes y Cosméticos',     'Francia',    1957, 1),
('Moët & Chandon',  'Vinos y Destilados',        'Francia',    1743, 1),
('Hennessy',        'Vinos y Destilados',        'Francia',    1765, 1),
('Bulgari',         'Relojes y Joyería',         'Italia',     1884, 1),
('TAG Heuer',       'Relojes y Joyería',         'Suiza',      1860, 1);

COMMIT;


-- ============================================================
-- PRODUCTOS por marca
-- ============================================================
BEGIN;

INSERT INTO productos (id_marca, nombre, categoria, precio_base) VALUES
-- Louis Vuitton (id_marca = 1)
(1, 'Bolso Neverfull MM',         'Bolsos',     1550.00),
(1, 'Bolso Speedy 30',            'Bolsos',     1050.00),
(1, 'Cinturón Monogram',          'Accesorios',  450.00),
(1, 'Zapatillas Archlight',       'Calzado',     850.00),
-- Dior (id_marca = 2)
(2, 'Bolso Lady Dior Medium',     'Bolsos',     4200.00),
(2, 'Vestido Bar Jacket',         'Ropa',       3800.00),
(2, 'Perfume J\'adore 100ml',     'Perfume',     145.00),
(2, 'Gafas DiorBlackSuit',        'Accesorios',  420.00),
-- Givenchy (id_marca = 3)
(3, 'Bolso Antigona Small',       'Bolsos',     1850.00),
(3, 'Zapatillas TK-360',          'Calzado',     650.00),
-- Fendi (id_marca = 4)
(4, 'Bolso Baguette',             'Bolsos',     2900.00),
(4, 'Abrigo FF Logo',             'Ropa',       4500.00),
-- Sephora (id_marca = 5)
(5, 'Paleta de sombras Rose Gold','Maquillaje',   45.00),
(5, 'Set Hidratación Premium',    'Cosmética',    89.00),
-- Parfums Givenchy (id_marca = 6)
(6, 'L\'Interdit EDP 80ml',       'Perfume',     135.00),
(6, 'Gentleman Eau de Parfum',    'Perfume',     115.00),
-- Moët & Chandon (id_marca = 7)
(7, 'Moët Impérial Brut 75cl',    'Champán',      55.00),
(7, 'Dom Pérignon 2015 75cl',     'Champán',     230.00),
-- Hennessy (id_marca = 8)
(8, 'Hennessy VS 70cl',           'Destilado',    45.00),
(8, 'Hennessy XO 70cl',           'Destilado',   230.00),
-- Bulgari (id_marca = 9)
(9, 'Anillo B.zero1 Oro',         'Joyería',    1200.00),
(9, 'Perfume BLV Femme 75ml',     'Perfume',      98.00),
-- TAG Heuer (id_marca = 10)
(10,'Reloj Carrera Calibre 5',    'Reloj',      2200.00),
(10,'Reloj Aquaracer Professional','Reloj',     1800.00);

COMMIT;


-- ============================================================
-- TIENDAS del grupo por ciudad
-- ============================================================
BEGIN;

INSERT INTO tiendas (nombre, ciudad, pais, tipo, metros_cuadrados) VALUES
('Louis Vuitton Champs-Élysées',  'París',         'Francia',        'Flagship',  2500),
('Dior Avenue Montaigne',         'París',         'Francia',        'Flagship',  1800),
('Sephora Rivoli',                'París',         'Francia',        'Flagship',   900),
('Louis Vuitton Bond Street',     'Londres',       'Reino Unido',    'Flagship',  1200),
('Fendi Via Condotti',            'Roma',          'Italia',         'Flagship',   800),
('Bulgari Via Condotti',          'Roma',          'Italia',         'Flagship',   600),
('Louis Vuitton Fifth Avenue',    'Nueva York',    'Estados Unidos', 'Flagship',  3000),
('Dior Beverly Hills',            'Los Ángeles',   'Estados Unidos', 'Flagship',  1100),
('Sephora Times Square',          'Nueva York',    'Estados Unidos', 'Flagship',  1500),
('TAG Heuer Ginebra',             'Ginebra',       'Suiza',          'Flagship',   400),
('LVMH Outlet La Vallée',         'París',         'Francia',        'Outlet',    5000),
('LVMH Online Store',             'Online',        'Global',         'Online',    NULL),
('Moët & Chandon Épernay',        'Épernay',       'Francia',        'Flagship',   300),
('Louis Vuitton Dubai Mall',      'Dubái',         'Emiratos Árabes','Flagship',  1600),
('Dior Ginza',                    'Tokio',         'Japón',          'Flagship',   950);

COMMIT;


-- ============================================================
-- CLIENTES ficticios (25 clientes de distintos países y segmentos)
-- ============================================================
BEGIN;

INSERT INTO clientes (nombre, apellido, email, pais, segmento, fecha_registro) VALUES
('Sophie',    'Laurent',    'sophie.laurent@email.fr',       'Francia',         'VIP',      '2021-03-15'),
('James',     'Harrison',   'james.harrison@email.co.uk',    'Reino Unido',     'VIP',      '2020-11-02'),
('Yuki',      'Tanaka',     'yuki.tanaka@email.jp',          'Japón',           'VIP',      '2022-01-20'),
('Maria',     'Rossi',      'maria.rossi@email.it',          'Italia',          'Estándar', '2022-05-10'),
('Carlos',    'Mendoza',    'carlos.mendoza@email.mx',       'México',          'Estándar', '2023-02-28'),
('Emma',      'Müller',     'emma.muller@email.de',          'Alemania',        'VIP',      '2021-07-14'),
('Ahmed',     'Al-Rashid',  'ahmed.alrashid@email.ae',       'Emiratos Árabes', 'VIP',      '2020-09-05'),
('Camille',   'Dubois',     'camille.dubois@email.fr',       'Francia',         'Estándar', '2023-06-01'),
('Lucas',     'Ferreira',   'lucas.ferreira@email.br',       'Brasil',          'Nuevo',    '2024-01-10'),
('Isabelle',  'Petit',      'isabelle.petit@email.fr',       'Francia',         'VIP',      '2019-12-20'),
('Michael',   'Johnson',    'michael.johnson@email.us',      'Estados Unidos',  'VIP',      '2021-04-03'),
('Lena',      'Schmidt',    'lena.schmidt@email.de',         'Alemania',        'Estándar', '2022-08-19'),
('Fatima',    'Zahra',      'fatima.zahra@email.ma',         'Marruecos',       'Nuevo',    '2024-02-14'),
('Oliver',    'Brown',      'oliver.brown@email.au',         'Australia',       'Estándar', '2023-03-22'),
('Mei',       'Chen',       'mei.chen@email.cn',             'China',           'VIP',      '2020-06-30'),
('Ana',       'García',     'ana.garcia@email.es',           'España',          'Estándar', '2023-09-11'),
('Pierre',    'Bernard',    'pierre.bernard@email.fr',       'Francia',         'Nuevo',    '2024-03-05'),
('Fatou',     'Diallo',     'fatou.diallo@email.sn',         'Senegal',         'Nuevo',    '2024-04-18'),
('Kenji',     'Yamamoto',   'kenji.yamamoto@email.jp',       'Japón',           'VIP',      '2021-10-07'),
('Laura',     'Bianchi',    'laura.bianchi@email.it',        'Italia',          'Estándar', '2022-12-01'),
('David',     'Wilson',     'david.wilson@email.us',         'Estados Unidos',  'VIP',      '2020-05-25'),
('Sara',      'Johansson',  'sara.johansson@email.se',       'Suecia',          'Estándar', '2023-07-08'),
('Hassan',    'Mansour',    'hassan.mansour@email.ae',       'Emiratos Árabes', 'VIP',      '2021-01-17'),
('Chloe',     'Martin',     'chloe.martin@email.fr',         'Francia',         'Estándar', '2022-10-30'),
('Rafael',    'Costa',      'rafael.costa@email.pt',         'Portugal',        'Nuevo',    '2024-05-20');

COMMIT;


-- ============================================================
-- CALENDARIO: generamos fechas del año 2023 y 2024
-- ============================================================
BEGIN;

INSERT INTO calendario (id_fecha, fecha, anio, trimestre, mes, nombre_mes, semana, dia_semana, es_fin_semana, temporada)
VALUES
-- 2023
(20230101,'2023-01-01',2023,1,1,'Enero',1,'Domingo',1,'FW22'),
(20230215,'2023-02-15',2023,1,2,'Febrero',7,'Miércoles',0,'FW22'),
(20230310,'2023-03-10',2023,1,3,'Marzo',10,'Viernes',0,'SS23'),
(20230415,'2023-04-15',2023,2,4,'Abril',15,'Sábado',1,'SS23'),
(20230520,'2023-05-20',2023,2,5,'Mayo',20,'Sábado',1,'SS23'),
(20230614,'2023-06-14',2023,2,6,'Junio',24,'Miércoles',0,'SS23'),
(20230720,'2023-07-20',2023,3,7,'Julio',29,'Jueves',0,'SS23'),
(20230815,'2023-08-15',2023,3,8,'Agosto',33,'Martes',0,'SS23'),
(20230910,'2023-09-10',2023,3,9,'Septiembre',37,'Domingo',1,'FW23'),
(20231025,'2023-10-25',2023,4,10,'Octubre',43,'Miércoles',0,'FW23'),
(20231115,'2023-11-15',2023,4,11,'Noviembre',46,'Miércoles',0,'FW23'),
(20231210,'2023-12-10',2023,4,12,'Diciembre',49,'Domingo',1,'FW23'),
(20231225,'2023-12-25',2023,4,12,'Diciembre',52,'Lunes',0,'FW23'),
-- 2024
(20240110,'2024-01-10',2024,1,1,'Enero',2,'Miércoles',0,'FW23'),
(20240214,'2024-02-14',2024,1,2,'Febrero',7,'Miércoles',0,'FW23'),
(20240320,'2024-03-20',2024,1,3,'Marzo',12,'Miércoles',0,'SS24'),
(20240410,'2024-04-10',2024,2,4,'Abril',15,'Miércoles',0,'SS24'),
(20240515,'2024-05-15',2024,2,5,'Mayo',20,'Miércoles',0,'SS24'),
(20240620,'2024-06-20',2024,2,6,'Junio',25,'Jueves',0,'SS24'),
(20240710,'2024-07-10',2024,3,7,'Julio',28,'Miércoles',0,'SS24'),
(20240814,'2024-08-14',2024,3,8,'Agosto',33,'Miércoles',0,'SS24'),
(20240918,'2024-09-18',2024,3,9,'Septiembre',38,'Miércoles',0,'FW24'),
(20241023,'2024-10-23',2024,4,10,'Octubre',43,'Miércoles',0,'FW24'),
(20241120,'2024-11-20',2024,4,11,'Noviembre',47,'Miércoles',0,'FW24'),
(20241215,'2024-12-15',2024,4,12,'Diciembre',50,'Domingo',1,'FW24'),
(20241224,'2024-12-24',2024,4,12,'Diciembre',52,'Martes',0,'FW24');

COMMIT;


-- ============================================================
-- VENTAS — 60 registros ficticios pero coherentes
-- ============================================================
BEGIN;

INSERT INTO ventas (id_cliente, id_producto, id_tienda, id_fecha, cantidad, precio_unitario, descuento, total) VALUES
-- Clientes VIP comprando bolsos y accesorios de lujo
(1,  1,  1,  20230415, 1, 1550.00, 0.00,  1550.00),  -- Sophie, Neverfull, París
(1,  5,  2,  20230520, 1, 4200.00, 0.00,  4200.00),  -- Sophie, Lady Dior, París
(2,  4,  4,  20230310, 1,  850.00, 0.00,   850.00),  -- James, Archlight, Londres
(2,  9,  4,  20230614, 1, 1850.00, 0.00,  1850.00),  -- James, Antigona, Londres
(3, 23,  15, 20230720, 1, 2200.00, 0.00,  2200.00),  -- Yuki, TAG Heuer, Tokio
(3,  5,  15, 20231025, 1, 4200.00, 0.00,  4200.00),  -- Yuki, Lady Dior, Tokio
(6,  6,  1,  20230215, 1, 3800.00, 0.00,  3800.00),  -- Emma, Vestido Dior, París
(7,  1,  14, 20230910, 2, 1550.00, 0.00,  3100.00),  -- Ahmed, 2x Neverfull, Dubái
(7, 21,  14, 20231115, 1, 1200.00, 0.00,  1200.00),  -- Ahmed, Bulgari anillo, Dubái
(10, 5,  1,  20230101, 1, 4200.00, 0.00,  4200.00),  -- Isabelle, Lady Dior, París
(10, 1,  1,  20231210, 1, 1550.00, 0.00,  1550.00),  -- Isabelle, Neverfull, París
(11, 7,  7,  20230415, 2,  145.00, 0.00,   290.00),  -- Michael, Perfume Dior, NY
(11,11,  7,  20230720, 1, 2900.00, 0.00,  2900.00),  -- Michael, Fendi Baguette, NY
(15, 2,  15, 20230310, 1, 1050.00, 0.00,  1050.00),  -- Mei, Speedy 30, Tokio
(15,11,  15, 20230614, 1, 2900.00, 0.00,  2900.00),  -- Mei, Fendi Baguette, Tokio
(19,23,  15, 20230815, 1, 2200.00, 0.00,  2200.00),  -- Kenji, TAG Heuer, Tokio
(21, 1,  7,  20230520, 1, 1550.00, 0.00,  1550.00),  -- David, Neverfull, NY
(21, 5,  7,  20231025, 1, 4200.00, 0.00,  4200.00),  -- David, Lady Dior, NY
(23, 3,  14, 20230910, 1,  450.00, 0.00,   450.00),  -- Hassan, Cinturón LV, Dubái
(23,24,  14, 20231115, 1, 1800.00, 0.00,  1800.00),  -- Hassan, Aquaracer, Dubái
-- Clientes Estándar comprando perfumes, cosméticos y accesorios
(4, 15,  5,  20230310, 1,  135.00, 0.00,   135.00),  -- Maria, L'Interdit, Roma
(4, 22,  5,  20230614, 1,   98.00, 0.00,    98.00),  -- Maria, Bulgari perfume, Roma
(5, 17,  12, 20230415, 3,   55.00, 0.00,   165.00),  -- Carlos, 3x Moët, Online
(8, 13,  3,  20230215, 2,   45.00, 0.00,    90.00),  -- Camille, Paleta Sephora, París
(8, 14,  3,  20230520, 1,   89.00, 0.00,    89.00),  -- Camille, Set Hidratación, París
(12,16,  1,  20230720, 1,  115.00, 0.00,   115.00),  -- Lena, Gentleman, París
(14, 7,  12, 20230815, 1,  145.00, 10.00,  130.50),  -- Oliver, Perfume Dior, Online (10% desc)
(16,13,  3,  20230910, 1,   45.00, 0.00,    45.00),  -- Ana, Paleta Sephora, París
(16,15,  3,  20231025, 2,  135.00, 0.00,   270.00),  -- Ana, 2x L'Interdit, París
(20, 4,  5,  20231115, 1,  850.00, 0.00,   850.00),  -- Laura, Archlight, Roma
(20,10,  5,  20231210, 1,  650.00, 0.00,   650.00),  -- Laura, TK-360 Givenchy, Roma
(22,17,  12, 20231225, 6,   55.00, 5.00,   312.75),  -- Sara, 6x Moët Navidad, Online
(24,13,  3,  20230101, 1,   45.00, 0.00,    45.00),  -- Chloe, Paleta Sephora, París
(24,14,  3,  20230615, 1,   89.00, 0.00,    89.00),  -- Chloe, Set Hidratación, París
-- Clientes Nuevos con primeras compras
(9, 17,  12, 20240110, 2,   55.00, 0.00,   110.00),  -- Lucas, 2x Moët, Online
(13,13,  3,  20240214, 1,   45.00, 0.00,    45.00),  -- Fatima, Paleta Sephora, París
(17,15,  3,  20240320, 1,  135.00, 0.00,   135.00),  -- Pierre, L'Interdit, París
(18,14,  12, 20240410, 1,   89.00, 0.00,    89.00),  -- Fatou, Set Hidratación, Online
(25,16,  12, 20240515, 1,  115.00, 0.00,   115.00),  -- Rafael, Gentleman, Online
-- 2024: más ventas para comparativa anual
(1,  2,  1,  20240214, 1, 1050.00, 0.00,  1050.00),  -- Sophie, Speedy 30, París
(1, 18,  1,  20240620, 2,  230.00, 0.00,   460.00),  -- Sophie, 2x Dom Pérignon, París
(2,  1,  4,  20240320, 1, 1550.00, 0.00,  1550.00),  -- James, Neverfull, Londres
(3, 24,  15, 20240410, 1, 1800.00, 0.00,  1800.00),  -- Yuki, Aquaracer, Tokio
(6, 12,  1,  20240515, 1, 4500.00, 0.00,  4500.00),  -- Emma, Abrigo Fendi, París
(7,  5,  14, 20240620, 1, 4200.00, 0.00,  4200.00),  -- Ahmed, Lady Dior, Dubái
(10, 9,  1,  20240710, 1, 1850.00, 0.00,  1850.00),  -- Isabelle, Antigona, París
(11,20,  7,  20240814, 1,  230.00, 0.00,   230.00),  -- Michael, Hennessy XO, NY
(15, 1,  15, 20240918, 1, 1550.00, 0.00,  1550.00),  -- Mei, Neverfull, Tokio
(19,23,  15, 20241023, 1, 2200.00, 0.00,  2200.00),  -- Kenji, TAG Heuer, Tokio
(21,11,  7,  20241120, 1, 2900.00, 0.00,  2900.00),  -- David, Fendi Baguette, NY
(23, 1,  14, 20241215, 2, 1550.00, 0.00,  3100.00),  -- Hassan, 2x Neverfull, Dubái
(4, 16,  5,  20240110, 1,  115.00, 0.00,   115.00),  -- Maria, Gentleman, Roma
(8, 17,  3,  20240214, 3,   55.00, 0.00,   165.00),  -- Camille, 3x Moët, París
(12,13,  3,  20240320, 2,   45.00, 0.00,    90.00),  -- Lena, 2x Paleta, París
(14,19,  12, 20240410, 1,   45.00, 0.00,    45.00),  -- Oliver, Hennessy VS, Online
(16, 7,  3,  20240515, 1,  145.00, 0.00,   145.00),  -- Ana, Perfume Dior, París
(20, 2,  5,  20240620, 1, 1050.00, 0.00,  1050.00),  -- Laura, Speedy 30, Roma
(22,18,  12, 20241224, 3,  230.00, 10.00,  621.00),  -- Sara, 3x Dom Pérignon Navidad, Online
(24, 9,  1,  20240710, 1, 1850.00, 0.00,  1850.00),  -- Chloe, Antigona, París
(16,14,  3,  20240814, 1,   89.00, 0.00,    89.00);  -- Ana, Set Hidratación, París

COMMIT;


-- ============================================================
-- UPDATE y DELETE de ejemplo (requeridos por el proyecto)
-- ============================================================

-- UPDATE: corregir el segmento de un cliente que ha pasado a VIP
UPDATE clientes
SET segmento = 'VIP'
WHERE email = 'chloe.martin@email.fr';

-- UPDATE: aplicar un 5% de descuento a ventas online de champán en Navidad
-- (simulamos una promoción que se olvidó aplicar)
UPDATE ventas
SET descuento = 5.00,
    total = calcular_total(precio_unitario, cantidad, 5.00)
WHERE id_tienda = 12
  AND id_fecha IN (20231225, 20241224)
  AND id_producto IN (17, 18);

-- DELETE: eliminar un registro duplicado ficticio (ejemplo de limpieza)
-- Primero lo insertamos para poder borrarlo
INSERT INTO ventas (id_cliente, id_producto, id_tienda, id_fecha, cantidad, precio_unitario, descuento, total)
VALUES (1, 1, 1, 20230415, 1, 1550.00, 0.00, 1550.00);  -- duplicado de la primera venta

-- Ahora lo eliminamos dejando solo el original (el de menor id)
DELETE FROM ventas
WHERE id_cliente = 1
  AND id_producto = 1
  AND id_tienda = 1
  AND id_fecha = 20230415
  AND id_venta > (
      SELECT min_id FROM (
          SELECT MIN(id_venta) AS min_id
          FROM ventas
          WHERE id_cliente = 1 AND id_producto = 1 AND id_tienda = 1 AND id_fecha = 20230415
      ) AS subquery
  );
