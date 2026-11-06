# --- Estágio 1: Builder (Instalação de dependências) ---
FROM python:3.13 AS builder

WORKDIR /app

# Instala dependências do sistema necessárias para compilar pacotes se necessário
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copia e instala as dependências Python em um diretório isolado
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt


# --- Estágio 2: Imagem Final (Runtime) ---
FROM python:3.13

WORKDIR /app

# Cria um usuário e grupo não-root por segurança
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Diretório persistente do SQLite, gravável apenas pelo usuário da aplicação
RUN mkdir -p /data \
    && chown appuser:appuser /data \
    && chmod 700 /data

# Copia as bibliotecas Python instaladas do estágio anterior
COPY --from=builder /root/.local /home/appuser/.local

# Copia o código da aplicação e o CSV inicial (se aplicável)
COPY . /app

# Ajusta as permissões da pasta para o usuário não-root (necessário para gravar o SQLite)
RUN chown -R appuser:appuser /app

# Altera para o usuário não-root
USER appuser

# Garanta que os executáveis do usuário estejam no PATH
ENV PATH=/home/appuser/.local/bin:$PATH

# Expõe a porta padrão do Uvicorn/FastAPI
EXPOSE 8000

# Comando para iniciar a aplicação
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]