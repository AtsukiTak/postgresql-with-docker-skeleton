PG_DATA=pgdata
PG_USER=postgres
PG_PASS=postgres
PG_PORT=15432
PG_URI=postgres://$(PG_USER):$(PG_PASS)@localhost:$(PG_PORT)/$(PG_DATA)
DOCKER_PG_NAME=pg-skeleton

start-db:
	docker run -d --rm -e POSTGRES_DB=$(PG_DATA) -e POSTGRES_PASSWORD=$(PG_PASS) -e POSTGRES_USER=$(PG_USER) --name $(DOCKER_PG_NAME) -p $(PG_PORT):5432 postgres

stop-db:
	docker stop $(DOCKER_PG_NAME) || true

restart-db: stop-db start-db

# Run sql file specified by $SQL variable
run-sql-on-db:
	docker run -it --rm -v $(CURDIR)/$(SQL):/root/$(SQL) -e PGPASSWORD=$(PG_PASS) --link $(DOCKER_PG_NAME):$(DOCKER_PG_NAME) postgres psql -h $(DOCKER_PG_NAME) -U $(PG_USER) -d $(PG_DATA) -f /root/$(SQL)

initialize-db:
	$(MAKE) run-sql-on-db SQL=initialize.sql

feed-test-data-to-db:
	$(MAKE) run-sql-on-db SQL=tests/data/test_data.sql

connect-db:
	docker run -it --rm -e PGPASSWORD=$(PG_PASS) --link $(DOCKER_PG_NAME):$(DOCKER_PG_NAME) postgres psql -h $(DOCKER_PG_NAME) -U $(PG_USER) -d $(PG_DATA)

echo-db-uri:
	echo $(PG_URI)

prepare-test:
	$(MAKE) restart-db
	sleep 5
	$(MAKE) initialize-db
	$(MAKE) feed-test-data-to-db
