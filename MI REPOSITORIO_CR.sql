-- 01. Agregar un nuevo propietario usando los campos reales
INSERT INTO tourism.owners (first_name, last_name, email, phone, company_name, tax_id, address_line1, city, state, country, postal_code) 
VALUES ('Juan', 'Pérez', 'juan.perez@example.com', '+503 7000-0000', 'Inversiones Pérez S.A.', '0614-010190-101-1', 'Paseo General Escalón #123', 'San Salvador', 'San Salvador', 'El Salvador', '01101');


-- 05. SELECT - Alojamientos activos
-- Descripción: Muestra la lista de todos los hospedajes que se encuentran activos actualmente en el sistema.

SELECT accommodation_id, Full_name, base_price_per_night, currency_code, bedroom_count, is_active
FROM tourism.accommodations
WHERE is_active = true;


-- Inspección de tabla
SELECT column_name 
FROM information_schema.columns 
WHERE table_schema = 'tourism' AND table_name = 'guests';

-- 06. SELECT - Huéspedes por país
-- Descripción: Muestra el listado de huéspedes ordenados y agrupados por su nacionalidad.

SELECT guest_id, first_name, last_name, email, nationality
FROM tourism.guests
ORDER BY nationality, last_name;

-- Inspección de tabla 
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_schema = 'tourism' AND table_name = 'bookings';

-- 07. SELECT - Reservas por fechas (Uso de BETWEEN)
-- Descripción: Filtra y muestra las reservas cuya fecha de entrada (check-in) se encuentra dentro de un rango específico.

SELECT booking_id, guest_id, accommodation_id, check_in_date, check_out_date, total_amount
FROM tourism.bookings
WHERE check_in_date BETWEEN '2026-01-01' AND '2026-04-30'
ORDER BY check_in_date;

-- 08. Actualizar precio de un alojamiento
-- Descripción: Modifica el precio base por noche de un hospedaje específico usando su ID.

UPDATE tourism.accommodations
SET base_price_per_night = 399.99
WHERE accommodation_id = 1;

-- 09. UPDATE - Actualizar estado de una reserva
-- Descripción: Modifica el identificador de estado de una reserva específica usando su ID único.

-- Paso 1: Actualizar el estado en la base de datos
UPDATE tourism.bookings
SET booking_status_id = 2
WHERE booking_id = 12;

-- Paso 2: Verificar el cambio de forma inmediata
SELECT booking_id, guest_id, booking_status_id, total_amount
FROM tourism.bookings
WHERE booking_id = 12;

-- Inspección de tabla
SELECT column_name 
FROM information_schema.columns 
WHERE table_schema = 'tourism' AND table_name = 'reviews';

-- 10. DELETE - Eliminar reseña específica
-- Descripción: Remueve permanentemente un registro de calificación del sistema utilizando su clave primaria.

-- Paso 1: Eliminar la fila de manera quirúrgica
DELETE FROM tourism.reviews
WHERE review_id = 1;

-- Paso 2: Verificar la remoción del registro
SELECT review_id, booking_id, rating, review_text
FROM tourism.reviews
WHERE review_id = 1;


-- Verificar columnas de bookings y de guests para encontrar la llave común
SELECT table_name, column_name, data_type 
FROM information_schema.columns 
WHERE table_schema = 'tourism' AND table_name IN ('bookings', 'guests');

-- 11. Relación de Reservas y Huéspedes
-- Descripción: Cruza la tabla de reservas con la de huéspedes usando la llave común guest_id.

SELECT 
    b.booking_id,
    g.first_name,
    g.last_name,
    b.check_in_date,
    b.total_amount
FROM tourism.bookings b
INNER JOIN tourism.guests g ON b.guest_id = g.guest_id
ORDER BY b.booking_id
LIMIT 10; 


-- Verificar columnas de bookings y de guests para encontrar la llave común
SELECT table_name, column_name, data_type 
FROM information_schema.columns 
WHERE table_schema = 'tourism' AND table_name IN ('bookings', 'guests');


-- Descubrir el nombre exacto de todas las tablas en el esquema tourism
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'tourism'
ORDER BY table_name;

SELECT table_name, column_name 
FROM information_schema.columns 
WHERE table_schema = 'tourism' AND table_name IN ('accommodations', 'locations');



-- 12. Alojamiento completo (INNER JOIN múltiple)
-- Descripción: Une la tabla de alojamientos con sus respectivos dueños y destinos geográficos.

SELECT 
    a.accommodation_id,
    a.name AS alojamiento,
    o.first_name AS nombre_dueno,
    o.last_name AS apellido_dueno,
    l.city AS ciudad_destino, -- Corregido: cambiamos 'name' por 'city'
    a.base_price_per_night AS precio
FROM tourism.accommodations a
INNER JOIN tourism.owners o ON a.owner_id = o.owner_id
INNER JOIN tourism.locations l ON a.location_id = l.location_id
ORDER BY a.accommodation_id
LIMIT 10;


-- Ver los campos de la tabla payments
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_schema = 'tourism' AND table_name = 'payments';


-- 13. Pagos + reservas (JOIN combinado)
-- Descripción: Combina la información de los pagos realizados con los detalles de sus respectivas reservas.

SELECT 
    p.payment_id,
    p.booking_id,
    p.amount AS monto_pagado,
    p.payment_method AS metodo_pago,
    p.payment_status AS estado_pago,
    b.check_in_date AS fecha_ingreso,
    b.check_out_date AS fecha_salida,
    b.total_amount AS total_reserva
FROM tourism.payments p
INNER JOIN tourism.bookings b ON p.booking_id = b.booking_id
ORDER BY p.payment_id
LIMIT 10;

-- Ver los campos de la tabla reviews
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_schema = 'tourism' AND table_name = 'reviews';



-- 14. LEFT JOIN - Alojamientos sin reseñas (Incluye nulls)
-- Descripción: Muestra todos los alojamientos y arrastra sus reseñas. Los que no tienen comentarios mostrarán NULL.

SELECT 
    a.accommodation_id,
    a.name AS alojamiento,
    r.review_id,
    r.rating AS calificacion,
    r.review_text AS comentario
FROM tourism.accommodations a
LEFT JOIN tourism.reviews r ON a.accommodation_id = r.accommodation_id
ORDER BY r.review_id ASC NULLS FIRST
LIMIT 15;




-- 15. LEFT JOIN - Alojamientos sin reservas (Filtrar null)
-- Descripción: Filtra y muestra únicamente las propiedades 
--que jamás han sido reservadas.

SELECT column_name 
FROM information_schema.columns 
WHERE table_schema = 'tourism' AND table_name = 'accommodations';

SELECT 
    a.accommodation_id,
    a.name AS alojamiento,
    a.base_price_per_night AS precio,
    b.booking_id AS codigo_reserva
FROM tourism.accommodations a
LEFT JOIN tourism.bookings b ON a.accommodation_id = b.accommodation_id
WHERE b.booking_id IS NULL
ORDER BY a.accommodation_id;


-- 16. AGG - Total de ingresos recaudados (SUM)
-- Descripción: Calcula la suma total acumulada de todos los pagos exitosos en la plataforma.

SELECT 
    COUNT(payment_id) AS cantidad_pagos_exitosos,
    SUM(amount) AS total_ingresos_recaudados
FROM tourism.payments
WHERE payment_status = 'Completed';


SELECT AVG(rating) AS promedio_rating
FROM reviews;


-- 17 Promedio rating 

SELECT
    accommodation_id,
    AVG(rating) AS promedio_rating
FROM tourism.reviews
GROUP BY accommodation_id
ORDER BY promedio_rating DESC;



--18 TOP ALOJAMIENTOS


SELECT *
FROM tourism.accommodations
LIMIT 1;


SELECT 
    accommodation_id, 
    COUNT(*) AS total_reservas
FROM 
    tourism.bookings
GROUP BY 
    accommodation_id
ORDER BY 
    total_reservas DESC
LIMIT 5; 


SELECT 
    id_cliente, -- O puedes cambiarlo por id_alojamiento
    COUNT(*) AS total_reservas
FROM 
    tourism.reservas
GROUP BY 
    id_cliente
HAVING 
    COUNT(*) > 3;


-- 19 MAS DE 3 RESERVAS POR ALOJAMIENTO 

	SELECT 
    guest_id, 
    COUNT(*) AS total_reservas
FROM 
    tourism.bookings
GROUP BY 
    guest_id
HAVING 
    COUNT(*) > 3;
	

-- 19 MAS DE 3 RESERVAS POR ALOJAMIENTO 

SELECT 
    accommodation_id, 
    COUNT(*) AS total_reservas
FROM 
    tourism.bookings
GROUP BY 
    accommodation_id
HAVING 
    COUNT(*) > 3;


--20 ALOJAMIENTO MAS CARO 

SELECT 
    *
FROM 
    tourism.accommodations
WHERE 
   base_price_per_night = (SELECT MAX(base_price_per_night) 
   FROM tourism.accommodations);

SELECT * FROM tourism.accommodations LIMIT 1;
