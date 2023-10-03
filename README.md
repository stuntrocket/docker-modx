# Docker (Quickstart)

## Build Containers
This will build the basic Docker service containers and mount the three LitEnc folders.
```php
./develop up -d --build
```

Check our containers were started.
```php
./develop

# is synonymous with
docker-compose -f docker-compose.dev.yml ps
```

**Containers**
- php-fpm
- mysql
- nginx

The container should now be visible at:
[http://localhost/][1]

## Without the Wrapper
Most of the commands can be executed without the **wrapper** if you prefer, by using the **docker-compose syntax** below.
```php

docker-compose -f docker-compose.dev.yml exec php-fpm sh -c "cd /var/www/html && php artisan"
```

### Troubleshooting
If you need to login and look around or issue commands manually:
```php
docker exec -it php-fpm sh
```

#### See Also
Key Terms:
Related Topics:

[1]:	http://localhost