import pandas as pd
import os
import sqlite3
from fastapi import FastAPI

app = FastAPI()
DB_PATH = os.getenv("DB_PATH", "/data/banco.db")

# 1. Ler o CSV e persistir no SQLite
def carregar_csv_para_banco():
    conexao = sqlite3.connect(DB_PATH)
    try:
        tabela_existe = conexao.execute(
            "SELECT 1 FROM sqlite_master "
            "WHERE type = 'table' AND name = 'tabela_dados'"
        ).fetchone()

        if tabela_existe is None:
            df = pd.read_csv("dados.csv")
            df.to_sql("tabela_dados", conexao, if_exists="fail", index=False)
    finally:
        conexao.close()

# Executa a carga ao iniciar (ou pode ser um endpoint)
carregar_csv_para_banco()

# 2. Subir a API para consumir os dados persistidos
@app.get("/dados")
def obter_dados():
    conexao = sqlite3.connect(DB_PATH)
    try:
        cursor = conexao.cursor()
        cursor.execute("SELECT * FROM tabela_dados")
        resultados = cursor.fetchall()
    finally:
        conexao.close()
    return {"dados": resultados}