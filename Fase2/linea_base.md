## Resultados 8 oct

A continuación se detalla la evaluación individual de los índices probados en el entorno de desarrollo/producción, registrando las métricas comparativas del plan de ejecución antes y después de su creación, así como el veredicto final sobre su permanencia.

| Consulta | Índice Propuesto / Experimento | Antes (Nodo, Buffers, ms) | Después (Nodo, Buffers, ms) | Veredicto | Explicación / Razón |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **C1** | `idx_pedidos_id_cliente` | `Nested Loop / Memoize`, 68 buffers, 19.980 ms | `Nested Loop / Memoize`, 68 buffers, 2.364 ms | **SE QUEDA** | Aceleración de 8.45x. Optimiza la búsqueda de la FK `id_cliente` al cruzar pedidos con clientes. |
| **C1 / C8** | `idx_detalle_pedidos_id_pedido` | `Merge Join / Index Scan`, 68 buffers, 21.420 ms | `Merge Join / Index Scan`, 68 buffers, 21.420 ms | **SE BORRÓ** *(Probado en C1)* | No cambió buffers ni tiempo en C1 por restricción de `LIMIT 20`. Se descartó temporalmente para C1. |
| **C7** | `idx_pedidos_mes` `((date_trunc('month', fecha)))` | `GroupAggregate (Sort)`, 167 buffers, 17.689 ms | `GroupAggregate (Index Scan)`, 167 buffers, 6.026 ms | **SE QUEDA** | Aceleración de 2.93x. Elimina el nodo `Sort` en memoria RAM al entregar los datos pre-ordenados por el índice de expresión. |
| **C7 (Parte 3)** | Reescritura Patrón I2 (`WHERE fecha >= ... AND fecha < ...`) | `Seq Scan` (con `date_trunc`), 167 buffers, 13.997 ms | `Seq Scan` (con rango), 167 buffers, 6.026 ms | **REESCRITA** | Al evitar la función `date_trunc` sobre la columna `fecha`, se reduce el costo de CPU por fila procesada a la mitad. |
| **C8** | `idx_detalle_pedidos_id_pedido` | `Hash Join / Seq Scan`, 607 buffers, 23.456 ms | `Hash Join / Index Scan`, 607 buffers, 18.210 ms | **SE QUEDA** | Optimiza el escaneo de llaves foráneas en la tabla intermedia durante agrupaciones masivas y cálculo de rankings. |
| **C8** | `idx_detalle_pedidos_id_platillo` | `Hash Join / Seq Scan`, 607 buffers, 23.456 ms | `Hash Join / Index Scan`, 607 buffers, 17.890 ms | **SE QUEDA** | Acelera los cruces en memoria con la tabla `menu` durante el cálculo del total vendido por platillo. |