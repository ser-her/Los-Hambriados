-- C1 · autor: luisferzp · ¿Cuáles son los últimos pedidos registrados con el detalle del cliente, platillo y cantidad?
SELECT c.nombre AS cliente, 
       p.fecha, 
       m.nom_plato AS producto, 
       d.cantidad
FROM pedidos p
JOIN clientes c        ON c.id_cliente = p.id_cliente
JOIN detalle_pedidos d ON d.id_pedido = p.id_pedido
JOIN menu m            ON m.id_platillo = d.id_platillo
LIMIT 20;

-- C2 · autor: luisferzp · ¿Qué clientes tienen menor actividad o no han realizado pedidos registrados?
SELECT c.nombre, 
       count(p.id_pedido) AS ventas
FROM clientes c
LEFT JOIN pedidos p ON p.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nombre
ORDER BY ventas
LIMIT 20;

-- C3 · autor: luisferzp · ¿Qué meses superan los 100 000 de ingreso total en el restaurante?
SELECT date_trunc('month', fecha) AS mes,
       count(*)   AS ventas,
       sum(monto) AS ingreso
FROM pagos
GROUP BY 1
HAVING sum(monto) > 100000
ORDER BY 1;

-- C4 · autor: luisferzp · ¿Qué pagos individuales superan el ticket promedio general consumido?
SELECT folio, id_pedido, fecha, monto
FROM pagos
WHERE monto > (SELECT avg(monto) FROM pagos)
ORDER BY monto DESC;

-- C5 · autor: luisferzp · ¿Qué platillos del menú nunca se han vendido en ningún pedido?
SELECT m.nom_plato
FROM menu m
WHERE NOT EXISTS (
  SELECT 1 
  FROM detalle_pedidos d
  WHERE d.id_platillo = m.id_platillo
);

-- C6 · autor: luisferzp · ¿Qué clientes tienen un gasto acumulado superior al consumo promedio de los clientes?
WITH gasto AS (
  SELECT p.id_cliente, 
         sum(pg.monto) AS total_cliente
  FROM pagos pg
  JOIN pedidos p ON p.id_pedido = pg.id_pedido
  GROUP BY p.id_cliente
)
SELECT c.nombre, g.total_cliente
FROM gasto g
JOIN clientes c USING (id_cliente)
WHERE g.total_cliente > (SELECT avg(total_cliente) FROM gasto)
ORDER BY g.total_cliente DESC;

-- C7 · autor: luisferzp · ¿Cómo se comporta el volumen de pedidos a lo largo de los meses del año?
SELECT 
    date_trunc('month', fecha) AS mes,
    count(*) AS total_pedidos
FROM pedidos
GROUP BY 1
ORDER BY 1;

-- C8 · autor: luisferzp · ¿Cuál es el ranking de los platillos más vendidos y con mayores ingresos por cada mes?
SELECT m.nom_plato AS platillo,
       date_trunc('month', p.fecha) AS mes,
       sum(d.cantidad) AS total_vendidos,
       sum(d.subtotal) AS ingreso_platillo,
       rank() OVER (PARTITION BY date_trunc('month', p.fecha)
                    ORDER BY sum(d.cantidad) DESC) AS lugar
FROM detalle_pedidos d
JOIN pedidos p ON p.id_pedido = d.id_pedido
JOIN menu m    ON m.id_platillo = d.id_platillo
GROUP BY m.id_platillo, m.nom_plato, date_trunc('month', p.fecha)
ORDER BY mes, lugar;