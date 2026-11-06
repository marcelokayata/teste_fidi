# Construir imagem
docker build -t minha-api-python .

# Executar container
docker run -p 8000:8000 minha-api-python


docker compose up --build

Evite docker compose down -v para preservar o volume