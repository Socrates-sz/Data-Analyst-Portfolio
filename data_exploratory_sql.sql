-- Pays by year and month
SELECT pago_id AS id, cantidad AS quantity,
		EXTRACT(YEAR FROM fecha_pago) AS year,
		EXTRACT(MONTH FROM fecha_pago) AS month
FROM pagos
ORDER BY year; 

-- Pays by city 

SELECT ciudades.ciudad_id AS city_id,
		ciudades.ciudad AS city,
		COUNT (*) AS rents_by_city
FROM ciudades
	FULL OUTER JOIN direcciones ON ciudades.ciudad_id = direcciones.ciudad_id
	FULL OUTER JOIN tiendas ON tiendas.direccion_id = direcciones.direccion_id
	FULL OUTER JOIN inventarios ON inventarios.tienda_id = tiendas.tienda_id
	FULL OUTER JOIN rentas ON inventarios.inventario_id = rentas.inventario_id
WHERE ciudad IS NOT NULL
GROUP BY ciudades.ciudad_id
ORDER BY rents_by_city DESC;

-- TOP 10 most rented movies using window function

SELECT
	peliculas.pelicula_id AS id,
	peliculas.titulo AS title,
	COUNT(*) AS rents_number,
	ROW_NUMBER () OVER (
		ORDER BY COUNT(*) DESC
	) AS position
FROM	rentas
	INNER JOIN inventarios ON rentas.inventario_id = inventarios.inventario_id
	INNER JOIN peliculas ON inventarios.pelicula_id = peliculas.pelicula_id
GROUP BY peliculas.pelicula_id
ORDER BY rents_number DESC
LIMIT 10;

-- Clients and their rents

SELECT 
		clientes.nombre AS name,
		clientes.apellido AS last_name,
		COUNT(*) AS rents_number,
		RANK () OVER (
		ORDER BY COUNT(*) DESC
	) AS position
FROM rentas
	INNER JOIN clientes ON rentas.cliente_id = clientes.cliente_id
GROUP BY clientes.cliente_id
ORDER BY rents_number DESC;



