Instalar dependências

bash
Copy
Edit
pip install fastapi uvicorn psycopg2 kafka-python
Rodar o Kafka

bash
Copy
Edit
docker-compose up -d
Executar os serviços

bash
Copy
Edit
uvicorn lancamentos:app --reload
uvicorn consolidacao:app --reload
Testar endpoints

Criar lançamento: POST /lancamentos/
Consultar saldo: GET /saldo/