import os
import psycopg
from psycopg.rows import dict_row
from fastapi import FastAPI, HTTPException
from dotenv import load_dotenv

load_dotenv()

app = FastAPI(title="API de Los Hambriados")
DATABASE_URL = os.environ["DATABASE_URL"]

# 1. Endpoint de Salud
@app.get("/salud")
def salud():
    with psycopg.connect(DATABASE_URL) as conn:
        conn.execute("SELECT 1")
    return {"estado": "ok"}

# 2. Endpoint de Listado General
@app.get("/pedidos")
def listar_pedidos(limite: int = 20):
    try:
        with psycopg.connect(DATABASE_URL, row_factory=dict_row) as conn:
            filas = conn.execute(
                "SELECT id_pedido, id_cliente, id_empleado, nmesa, fecha, estado FROM public.pedidos LIMIT %s",
                (limite,)
            ).fetchall()
            return filas
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# 3. Endpoint por Llave Primaria (Parte 3 de la guía)
@app.get("/pedidos/{id_pedido}")
def obtener_pedido(id_pedido: int):
    try:
        with psycopg.connect(DATABASE_URL, row_factory=dict_row) as conn:
            fila = conn.execute(
                "SELECT id_pedido, id_cliente, id_empleado, nmesa, fecha, estado FROM public.pedidos WHERE id_pedido = %s",
                (id_pedido,)
            ).fetchone()
            
            if fila is None:
                raise HTTPException(status_code=404, detail="Pedido no encontrado")
                
            return fila
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))