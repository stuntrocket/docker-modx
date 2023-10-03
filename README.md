# Docker PHP NGINX

## Local Workstation

`~/Code/Project/provision/docker`

## Repositories

[stuntrocket/docker-php-nginx](https://github.com/stuntrocket/docker-php-nginx)

[stuntrocket/docker-php-apache](https://github.com/stuntrocket/docker-php-apache)

## 🦄 Helper

We can use the helper to abstract some harder to remember commands.

```shell
chmod 777 ./develop
```

### ⬆️ Up

Synonymous with `docker-compose up -d`

```shell
./develop up -d
```

### ⬇️ Down

```shell
./develop down
```

### Checking the container processes.

```other
develop ps
```

### 🧹 Other Commands

The helper is just a proxy for ::docker-compose:: and simply attempts to run commands against the relevant containers.

```shell
if [ "$1" == "artisan" ]; then
    shift 1
    $COMPOSE run --rm $TTY \
        -w /var/www/html \
        app.test \
        php artisan "$@"

elif [ "$1" == "composer" ]; then
    shift 1
    $COMPOSE run --rm $TTY \
        -w /var/www/html \
        app.test \
        composer "$@"

elif [ "$1" == "init" ]; then
    shift 1
    $COMPOSE run --rm $TTY \
        -w /var/www/html \
        app.test \
        bash ./docker/app/init.sh

elif [ "$1" == "mage" ]; then
    shift 1
    $COMPOSE run --rm $TTY \
        -w /var/www/html \
        app.test \
        php bin/magento "$@"

elif [ "$1" == "test" ]; then
    shift 1
    $COMPOSE run --rm $TTY \
        -w /var/www/html \
        app.test \
        ./vendor/bin/phpunit "$@"

elif [ "$1" == "t" ]; then
    shift 1
    $COMPOSE exec \
        app.test \
        sh -c "cd /var/www/html && ./vendor/bin/phpunit $@"

elif [ "$1" == "npm" ]; then
    shift 1
    $COMPOSE run --rm $TTY \
        -w /var/www/html \
        node \
        npm "$@"

elif [ "$1" == "yarn" ]; then
    shift 1
    $COMPOSE run --rm $TTY \
        -w /var/www/html \
        node \
        yarn "$@"

elif [ "$1" == "gulp" ]; then
    shift 1
    $COMPOSE run --rm $TTY \
        -w /var/www/html \
        node \
        ./node_modules/.bin/gulp "$@"
else
    $COMPOSE "$@"
fi
```

For example to migrate a Laravel database we can do:

```other
./develop artisan migrate
```

> Check the ::develop:: file to see what is available.

### ⚙️ Config

The helper also defines a simple set of configuration variables for setting up the database user, password etc. These are OK on local workstations but not in production.

```other
# Set environment variables for dev or CI

export APP_PORT=${APP_PORT:-80}

export DB_PORT=${DB_PORT:-3306}
export DB_ROOT_PASS=${DB_ROOT_PASS:-secret}
export DB_NAME=${DB_NAME:-homestead}
export DB_USER=${DB_USER:-homestead}
export DB_PASS=${DB_PASS:-secret}

# e.g mysql:8.0
# e.g mysql:5.7
export DB_IMAGE=${DB_IMAGE:-bitnami/mariadb}
```

These can be overridden at runtime if needed.

```shell
DB_PASS=reallysecret ./develop up -d --build
```

## 🗄 Database

There is a basic database starting point that can be extended to seed your database in ::docker/mysql/init.sql.::

### Connecting From Host

Because we use the ::expose::

attribute in our docker-compose.yml we can connect to the G::uest:: database from the H::ost:: workstation using SequelPro, Querious GUI, or use the develop tool to interact with Mysql CLI.

### Mysql Container

```shell
./develop ps

docker exec docker-php_mysql_1 mysql -uhomestead -psecret -e "create database new_database"
```
 