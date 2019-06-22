.PHONY : build clean spec start stop up

all : build up

build :
	docker-compose build

clean :
	docker-compose down
	docker-compose rm
	docker image prune
	docker volume prune

spec :
	RAILS_ENV=test docker-compose run --rm app rspec $(file)

start :
	docker-compose up -d

stop :
	docker-compose stop

up :
	docker-compose up

restart :
	docker-compose stop
	docker-compose up -d
