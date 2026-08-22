include .env
export  

export PROJECT_ROOT=${shell pwd}

infra-up:
	docker compose up -d todoapp-postgres
	

infra-down:
	docker compose down todoapp-postgres

infra-postgres-cleanup:
	@read -p "Очистить все volume файлы PostgreSQL? Опасность утери данных. [y/n]: " ans; \
	if [ "$$ans" = "y" ]; then \
		docker compose down todoapp-postgres && \
		rm -rf out/pgdata && \
		echo "Файлы окружения очищены."; \
	else \
		echo "Очистка PostgreSQL volumes отменена."; \
	fi 
