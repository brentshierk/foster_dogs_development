start: 
	docker-compose up -d

start-build: 
	docker-compose up --build -d

install: 
	- docker network create lambda-local
	cp .env-template .env
	make start-build

clean: 
	docker-compose down --rm local
	rm -rf docker/data/.data
	docker-compose rm

debug: 
	docker-compose up

restart: 
	make stop 
	make start

setup-db: 
	docker exec -it foster-roster_app_1 rake db:setup

stop:
	- rm ./tmp/pids/server.pid
	docker-compose down

#############################################################
# "Help Documentation"
#############################################################

help:
	@echo "Foster Roster Commands"
	@echo "  |"
	@echo "  |_ clean                 - Remove all artifacts created from the installation process"
	@echo "  |_ help                  - Show this message"
	@echo "  |_ run                   - Bring up the application and database in the foreground"
	@echo "  |_ setup-db              - Run the rake task to initialize the db"
	@echo "  |_ install               - Build, initialize database, and run in the background"
	@echo "  |_ start                 - (default)Bring up the application and database in the background"
	@echo "  |_ start-build           - Bring up the application and database in the background (and rebuild containers)"
	@echo "  |_ debug                 - Bring up the application and database in this terminal session"
	@echo "  |_ stop                  - Bring down the application"
	@echo "  |__________________________________________________________________________________________"
	@echo " "
