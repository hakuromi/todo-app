include .env
export  

export PROJECT_ROOT=${shell pwd}

infra-up:
	@docker compose up -d todoapp-postgres
	

infra-down:
	@docker compose down todoapp-postgres

infra-postgres-cleanup:
	@read -p "Очистить все volume файлы PostgreSQL? Опасность утери данных. [y/n]: " ans; \
	if [ "$$ans" = "y" ]; then \
		docker compose down todoapp-postgres && \
		rm -rf out/pgdata && \
		echo "Файлы окружения очищены."; \
	else \
		echo "Очистка PostgreSQL volumes отменена."; \
	fi 

migrate-create:
	@if [ -z "$(seq)" ]; then \
		echo "Отсутствует необходимый параметр 'seq'. Пример: make migrate-create seq=init"; \
		exit 1; \
	fi; \
	docker compose run --rm todoapp-postgres-migrate \
		create \
		-ext sql \
		-dir /migrations \
		-seq "$(seq)"

migrate-up:
	@make migrate-action action=up

migrate-down:
	@make migrate-action action=down

migrate-action:
	@if [ -z "$(action)" ]; then \
		echo "Отсутствует необходимый параметр 'action'. Пример: make migrate-action action=up 1"; \
		exit 1; \
	fi; \
	docker compose run --rm todoapp-postgres-migrate \
		-path /migrations \
		-database postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@todoapp-postgres:5432/${POSTGRES_DB}?sslmode=disable \
		"${action}"