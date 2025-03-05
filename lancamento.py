from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import psycopg2
from kafka import KafkaProducer
import json

app = FastAPI()

# Configuração do Kafka
producer = KafkaProducer(
    bootstrap_servers="localhost:9092",
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

# Modelo de entrada
class Lancamento(BaseModel):
    tipo: str  # "credito" ou "debito"
    valor: float

@app.post("/lancamentos/")
def criar_lancamento(lancamento: Lancamento):
    if lancamento.tipo not in ["credito", "debito"]:
        raise HTTPException(status_code=400, detail="Tipo inválido")

    # Enviar evento para Kafka
    producer.send("lancamentos", value=lancamento.dict())

    return {"message": "Lançamento registrado com sucesso"}
