isDocker := $(shell docker info > /dev/null 2>&1 && echo 1)
domain := "locale.dev"
server := "contact@$(domain)"
user := $(shell id -u)
group := $(shell id -g)
dc := USER_ID=$(user) GROUP_ID=$(group) docker-compose
de := docker-compose exec
dr := $(dc) run --rm
sy := $(de) app bin/console
php := $(dr) --no-deps app
.DEFAULT_GOAL := help
testdb := $(de) db mysql -uroot -pnotsecret symfony-job-interview -e

.PHONY: help
help: ## Affiche cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Lance le docker-compose build
	$(dc) build

.PHONY: start
start:  ## Lance le serveur de développement
	$(dc) up -d

.PHONY: stop
stop: ## Stopper le serveur de développement
	$(dc) down

.PHONY: reset
reset: ## ReInitialisé la base de données (docker-compose up doit être lancé)
	$(sy) doctrine:database:drop --force -q
	$(sy) doctrine:database:create -q
	$(sy) doctrine:migrations:migrate -q
	$(sy) doctrine:schema:validate -q
	$(sy) doctrine:fixtures:load -q

.PHONY: init
init: ## Initialisé la base de données (docker-compose up doit être lancé)
	$(sy) doctrine:database:create -q
	$(sy) doctrine:migrations:migrate -q
	$(sy) doctrine:schema:validate -q
	$(sy) doctrine:fixtures:load -q

.PHONY: createdb
create_db: ## creation de la base de données (docker-compose up doit être lancé)
	$(sy) doctrine:database:create -q

.PHONY: deletedb
delete_db: ## suppression de la base de données (docker-compose up doit être lancé)
	$(sy) doctrine:database:drop --force -q

.PHONY: load
load: ## load fixtures
	$(sy) doctrine:fixtures:load -q

.PHONY: seed
seed: ## Génère des données dans la base de données (docker-compose up doit être lancé)
	$(sy) doctrine:migrations:migrate -q
	$(sy) doctrine:schema:validate -q
	$(sy) doctrine:fixtures:load -q

.PHONY: mm
mm: ## Génère les migrations et migre la base de données (docker-compose up doit être lancé)
	$(sy) make:migration -q
	$(sy) doctrine:migrations:migrate -q

.PHONY: migration
migration: ## Génère les migrations
	$(sy) make:migration

.PHONY: migrate
migrate: ## Migre la base de données (docker-compose up doit être lancé)
	$(sy) doctrine:migrations:migrate -q

.PHONY: rendement
rendement: ## Lancer le calcule automatique des rendements
	$(sy) app:calculate:rendement -q

.PHONY: rollback
rollback:
	$(sy) doctrine:migration:migrate prev

.PHONY: lint
lint: ## Analyse le code
	./vendor/bin/phpstan analyse

.PHONY: format
format: ## Formate le code
	npx prettier-standard --lint --changed "assets/**/*.{js,css,jsx}"
	./vendor/bin/phpcbf
	./vendor/bin/php-cs-fixer fix

.PHONY: doc
doc: ## Génère le sommaire de la documentation
	npx doctoc ./README.md

.PHONY: doc
fixtures: ## Alimenter la base avec les dataFixtures
	$(testdb) "DROP TABLE IF EXISTS uri; CREATE TABLE uri (id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, url VARCHAR(1000) NOT NULL, token VARCHAR(255) NOT NULL, times_used INT UNSIGNED NOT NULL);"
	$(testdb) "INSERT INTO uri VALUES (NULL, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 'some_token', 0);"



