.PHONY : build clean spec start stop up services

all : build up

build :
	docker-compose build

clean :
	docker-compose down
	docker-compose rm
	docker image prune
	docker volume prune

services :
	docker-compose up -d pg redis

spec :
	RAILS_ENV=test docker-compose run --rm app rspec $(file)

start :
	docker-compose up -d

stop :
	docker-compose stop

up :
	docker-compose up

restart : stop start

rebuild : stop build start
