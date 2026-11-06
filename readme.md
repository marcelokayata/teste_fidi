# API com SQLite

## Iniciar

Construa a imagem e inicie os serviços com Docker Compose:

```bash
docker compose up --build
```

A API fica disponível em `http://localhost:8000`. Para iniciar em segundo plano:

```bash
docker compose up --build -d
```

## Banco de dados

O serviço `api` usa o banco `/data/banco.db`. O diretório `/data` é persistido no volume nomeado `sqlite_data`, declarado no `docker-compose.yml`.

Confira os arquivos do volume a partir do container:

```bash
docker compose exec api ls -l /data
```

Consulte algumas linhas da tabela usando o módulo SQLite do Python, disponível no container:

```bash
docker compose exec api python -c "import sqlite3; c=sqlite3.connect('/data/banco.db'); print(c.execute('SELECT * FROM tabela_dados LIMIT 10').fetchall()); c.close()"
```

Para copiar o arquivo do banco para a pasta atual:

```bash
docker compose cp api:/data/banco.db ./banco.db
```

O nome real do volume pode incluir o nome do projeto Compose. Para encontrá-lo e ver seus detalhes:

```bash
docker volume ls
docker volume inspect <nome-do-volume>
```

No Linux, o campo `Mountpoint` do `inspect` informa onde o Docker armazena o volume no host. Com Docker Desktop, os dados ficam dentro da máquina virtual do Docker; use `docker compose cp` para obter uma cópia no sistema local.

## Parar

Para parar os serviços sem remover os dados:

```bash
docker compose down
```

Evite `docker compose down -v`: a opção `-v` remove o volume e apaga os dados persistidos.