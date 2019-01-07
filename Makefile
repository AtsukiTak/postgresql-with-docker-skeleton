PG_DATA=pgdata
PG_USER=postgres
PG_PASS=postgres
PG_PORT=5432
PG_URL=postgres://$(PG_USER):$(PG_PASS)@localhost:$(PG_PORT)/$(PG_DATA)
DOCKER_PG_NAME=pg-skeleton

start-db:
	docker run -d --rm -e POSTGRES_DB=$(PG_DATA) -e POSTGRES_PASSWORD=$(PG_PASS) -e POSTGRES_USER=$(PG_USER) --name $(DOCKER_PG_NAME) -p $(PG_PORT):5432 postgres

stop-db:
	docker stop $(DOCKER_PG_NAME)

initialize-db:
	docker run -it --rm -v $(CURDIR)/initialize.sql:/root/initialize.sql -e PGPASSWORD=$(PG_PASS) --link $(DOCKER_PG_NAME):$(DOCKER_PG_NAME) postgres psql -h $(DOCKER_PG_NAME) -U $(PG_USER) -d $(PG_DATA) -f /root/initialize.sql

connect-db:
	docker run -it --rm -e PGPASSWORD=$(PG_PASS) --link $(DOCKER_PG_NAME):$(DOCKER_PG_NAME) postgres psql -h $(DOCKER_PG_NAME) -U $(PG_USER) -d $(PG_DATA)
