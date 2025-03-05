from fastapi import FastAPI
import psycopg2
from kafka import KafkaConsumer
import json

app = FastAPI()

# Configuração do Kafka
consumer = KafkaConsumer(
    "lancamentos",
    bootstrap_servers="localhost:9092",
    value_deserializer=lambda x: json.loads(x.decode("utf-8"))
)

# Processa os lançamentos recebidos do Kafka
for message in consumer:
    lancamento = message.value
    print(f"Processando lançamento: {lancamento}")

@app.get("/saldo/")
def obter_saldo():
    return {"saldo": 1000}  # Simulação