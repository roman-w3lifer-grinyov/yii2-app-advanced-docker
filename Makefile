default:
	@echo 'Enter command'

__initialization-an-existing-project: \
	up \
	composer-i \
	__yii-init __change-config \
	yii-migrate \
	yii-cache-flush-all \
	bash

start: \
	down \
	yii-migrate-down \
	git-pull \
	up \
	composer-i \
	yii-migrate \
	yii-cache-flush-all \
	bash

up:
	docker compose up -d --build --remove-orphans

down:
	docker compose down -v --remove-orphans
	docker network prune -f

git-pull:
	git pull

composer-i:
	docker compose exec php-fpm composer i

yii-migrate:
	docker compose exec php-fpm php yii migrate --interactive=0

yii-migrate-down:
	docker compose run --rm php-fpm php yii migrate/down 99999 --interactive=0

yii-cache-flush-all:
	docker compose exec php-fpm php yii cache/flush-all

bash:
	docker compose exec php-fpm bash

__yii-init:
	docker compose exec php-fpm php init --env=Development --overwrite=All --delete=All

__change-config:
	cp ./.docker/.helpers/change-config.php ./app
	docker compose exec php-fpm php change-config.php
	rm ./app/change-config.php

# ----------------------------------------------------------------------------------------------------------------------

__initialization: \
	down up \
	create-project __yii-init __change-config \
	yii-migrate \
	clear-initialization-files \
	git-init \
	bash

create-project:
	docker compose exec php-fpm rm .gitkeep
	docker compose exec php-fpm composer create-project --no-interaction --prefer-dist yiisoft/yii2-app-advanced .

clear-initialization-files:
	cp ./.docker/.helpers/clear-makefile.php ./app
	cp ./Makefile ./app/Makefile
	docker compose exec php-fpm php clear-makefile.php
	mv ./app/Makefile ./Makefile
	rm ./app/clear-makefile.php
	rm -r ./.docker/.helpers

git-init:
	rm -fr .git
	git init
