include .env
export  

export PROJECT_ROOT=${shell pwd}


infra-up:
	docker compose up -d todoapp-postgres
	

infra-down:
	docker compose down todoapp-postgres
