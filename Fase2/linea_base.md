| QUERY PLAN  C7                                                                                                          |
| --------------------------------------------------------------------------------------------------------------------- |
| GroupAggregate  (cost=1845.77..2245.77 rows=20000 width=16) (actual time=12.924..14.959 rows=13 loops=1)              |
|   Group Key: (date_trunc('month'::text, fecha))                                                                       |
|   ->  Sort  (cost=1845.77..1895.77 rows=20000 width=8) (actual time=12.718..13.650 rows=20000 loops=1)                |
|         Sort Key: (date_trunc('month'::text, fecha))                                                                  |
|         Sort Method: quicksort  Memory: 769kB                                                                         |
|         ->  Seq Scan on pedidos  (cost=0.00..417.00 rows=20000 width=8) (actual time=1.383..8.801 rows=20000 loops=1) |
| Planning Time: 10.895 ms                                                                                              |
| Execution Time: 17.689 ms                                                                                    
| QUERY PLAN  C8                                                                                                                                                   |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Incremental Sort  (cost=2637.03..4375.44 rows=12644 width=278) (actual time=23.049..23.056 rows=13 loops=1)                                                    |
|   Sort Key: (date_trunc('month'::text, p.fecha)), (rank() OVER (?))                                                                                            |
|   Presorted Key: (date_trunc('month'::text, p.fecha))                                                                                                          |
|   Full-sort Groups: 1  Sort Method: quicksort  Average Memory: 25kB  Peak Memory: 25kB                                                                         |
|   ->  WindowAgg  (cost=2636.92..3806.46 rows=12644 width=278) (actual time=22.993..23.008 rows=13 loops=1)                                                     |
|         ->  Incremental Sort  (cost=2636.92..3553.58 rows=12644 width=270) (actual time=22.986..22.991 rows=13 loops=1)                                        |
|               Sort Key: (date_trunc('month'::text, p.fecha)), (sum(d.cantidad)) DESC                                                                           |
|               Presorted Key: (date_trunc('month'::text, p.fecha))                                                                                              |
|               Full-sort Groups: 1  Sort Method: quicksort  Average Memory: 25kB  Peak Memory: 25kB                                                             |
|               ->  GroupAggregate  (cost=2636.89..2984.60 rows=12644 width=270) (actual time=20.284..22.921 rows=13 loops=1)                                    |
|                     Group Key: (date_trunc('month'::text, p.fecha)), m.id_platillo                                                                             |
|                     ->  Sort  (cost=2636.89..2668.50 rows=12644 width=239) (actual time=20.045..20.806 rows=12644 loops=1)                                     |
|                           Sort Key: (date_trunc('month'::text, p.fecha)), m.id_platillo                                                                        |
|                           Sort Method: quicksort  Memory: 1076kB                                                                                               |
|                           ->  Hash Join  (cost=633.08..939.04 rows=12644 width=239) (actual time=6.352..16.293 rows=12644 loops=1)                             |
|                                 Hash Cond: (d.id_platillo = m.id_platillo)                                                                                     |
|                                 ->  Hash Join  (cost=617.00..857.64 rows=12644 width=21) (actual time=6.223..12.765 rows=12644 loops=1)                        |
|                                       Hash Cond: (d.id_pedido = p.id_pedido)                                                                                   |
|                                       ->  Seq Scan on detalle_pedidos d  (cost=0.00..207.44 rows=12644 width=17) (actual time=0.017..1.785 rows=12644 loops=1) |
|                                       ->  Hash  (cost=367.00..367.00 rows=20000 width=12) (actual time=5.986..5.987 rows=20000 loops=1)                        |
|                                             Buckets: 32768  Batches: 1  Memory Usage: 1116kB                                                                   |
|                                             ->  Seq Scan on pedidos p  (cost=0.00..367.00 rows=20000 width=12) (actual time=0.023..2.414 rows=20000 loops=1)   |
|                                 ->  Hash  (cost=12.70..12.70 rows=270 width=222) (actual time=0.096..0.097 rows=16 loops=1)                                    |
|                                       Buckets: 1024  Batches: 1  Memory Usage: 9kB                                                                             |
|                                       ->  Seq Scan on menu m  (cost=0.00..12.70 rows=270 width=222) (actual time=0.084..0.086 rows=16 loops=1)                 |
| Planning Time: 1.281 ms                                                                                                                                        |
| Execution Time: 23.456 ms                                                                                                                                      |         |