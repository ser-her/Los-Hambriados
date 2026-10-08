-- =============================================================================
-- FASE 2: ÍNDICES PROPUESTOS Y DEPOSITADOS EN PRODUCCIÓN
-- Archivo: fase2/indices.sql
-- =============================================================================

-- C1 · autor: luisferzp · FK sin índice en la relación pedidos-clientes; optimiza los cruces relacionales dentro del JOIN con LIMIT 20
CREATE INDEX IF NOT EXISTS idx_pedidos_id_cliente 
ON pedidos(id_cliente);

-- C7 · autor: luisferzp · Índice basado en expresiones sobre la fecha truncada por mes; evita el algoritmo Sort en RAM para agrupaciones masivas
CREATE INDEX IF NOT EXISTS idx_pedidos_mes 
ON pedidos((date_trunc('month', fecha)));

-- C8 · autor: luisferzp · FK sin índice en detalle_pedidos; acelera la unión de tablas intermedias previa al cálculo del ranking con RANK()
CREATE INDEX IF NOT EXISTS idx_detalle_pedidos_id_pedido 
ON detalle_pedidos(id_pedido);

-- C8 · autor: luisferzp · FK sin índice hacia menú; optimiza el Hash Join masivo durante la agrupación de ingresos por platillo
CREATE INDEX IF NOT EXISTS idx_detalle_pedidos_id_platillo 
ON detalle_pedidos(id_platillo);    