# Docker (Quickstart)

[More notes here](https://app.heptabase.com/w/d9f492c25e2e7daf92d5c5ce582c8e288b90724ff9c48e805f2a1dc054fbca2e)

## Build Containers
This will build the basic Docker service containers and mount the three LitEnc folders. 
```php
./develop up -d --build && ./develop init
```

Check our containers were started.
```php
./develop

# is synonymous with
docker-compose -f docker-compose.dev.yml ps
```

**Containers**
- litenc
- mysql
- solr

## Initialise App
The containers should be running but we still need to **initialise** some things.
Using the single **init** command we can run our basic setup. 
I have included each step below in case you want to run them individually, otherwise, this one should work OK.
```php
./develop init
```

The container should now be visible at:
[http://127.0.0.1:1025/][1]

This will run the following **setup**.
1. Composer
2. NPM
3. Vendor files
4. Build Assets
5. Laravel Initialisation

### 1\. Composer
Install the Laravel dependencies.
```php
./develop composer install
```

### 2\. NPM
Install the NPM packages
```php
./develop npm install
```

### 3\. Vendor files
```php
./develop editor
```

### 4\. Build Assets
```php
./develop npx mix
```

### 5\. Laravel Initialisation
```php
./develop artisan migrate --force
./develop artisan storage:link

# optional
./develop artisan config:cache
```

## Without the Wrapper
Most of the commands can be executed without the **wrapper** if you prefer, by using the **docker-compose syntax** below.
```php

docker-compose -f docker-compose.dev.yml exec litenc sh -c "cd /var/www/html/le_enhanced && php artisan"
```

### Troubleshooting
If you need to login and look around or issue commands manually:
```php
docker exec -it litenc sh
```

#### Log Files
```php
/var/www/html/access.log
/var/www/html/error.log
```

#### See Also
LitEnc - Docker
Key Terms: 
Related Topics:

[1]:	http://127.0.0.1:1025