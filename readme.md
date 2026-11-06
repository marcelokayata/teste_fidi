# API com SQLite

API FastAPI que carrega `dados.csv` para uma tabela SQLite e disponibiliza os registros pela rota `/dados`. O banco fica em um volume Docker persistente.

## Iniciar a aplicação

Na pasta do projeto, construa a imagem e inicie o serviço:

```bash
docker compose up --build
```

Para iniciar em segundo plano:

```bash
docker compose up --build -d
```

## Acessar a API

Acesse a rota de dados em:

```text
http://localhost:8000/dados
```

Ou faça uma requisição pelo terminal:

```bash
curl http://localhost:8000/dados
```

No WSL2, abra o endereço `localhost` no navegador do Windows. `0.0.0.0` é o endereço de escuta do servidor, não o endereço a digitar no navegador.

## Banco e volume

O serviço `api` usa o banco `/data/banco.db`. No `docker-compose.yml`, o volume nomeado `sqlite_data` é montado em `/data`, mantendo o arquivo do banco mesmo quando o container é recriado.

Confira os arquivos do banco dentro do container:

```bash
docker compose exec api ls -l /data
```

Consulte até 10 linhas da tabela usando o SQLite disponível no Python do container:

```bash
docker compose exec api python -c "import sqlite3; c=sqlite3.connect('/data/banco.db'); print(c.execute('SELECT * FROM tabela_dados LIMIT 10').fetchall()); c.close()"
```

Copie o banco do container para a pasta atual:

```bash
docker compose cp api:/data/banco.db ./banco.db
```

O nome real do volume pode incluir o nome do projeto Compose. Liste os volumes para encontrá-lo e, em seguida, inspecione-o:

```bash
docker volume ls
docker volume inspect <nome-do-volume>
```

No Linux, o campo `Mountpoint` informa onde o Docker armazena o volume no host. No Docker Desktop, os dados ficam dentro da máquina virtual do Docker; use `docker compose cp` para obter uma cópia no sistema local.

## Parar sem apagar os dados

Pare e remova o container mantendo o volume:

```bash
docker compose down
```

Evite `docker compose down -v`: a opção `-v` remove o volume e apaga o banco persistido.