# DesafioArquitetura
Desafio de arquitetura
Como Rodar o Projeto

1. Instalar Dependências

pip install fastapi uvicorn psycopg2 kafka-python

2. Rodar o Kafka (usando Docker Compose)

docker-compose up -d

3. Executar os Serviços

Serviço de Lançamentos:

uvicorn lancamentos:app --reload

Serviço de Consolidação:

uvicorn consolidacao:app --reload

4. Testar Endpoints

Criar Lançamento:

POST /lancamentos/
Body: {"tipo": "credito", "valor": 100.0}

Consultar Saldo:

GET /saldo/
