## Launch

```bash
docker-compose up
```

## Configuration

Variables are set in [.env](.env)

Important variables:

* `MYSQL_ROOT_PASSWORD` mariadb root password
* `SEAFILE_MARIADB_USER` mariadb user used by seafile server
* `SEAFILE_MARIADB_PASSWORD` password for above user
* `SEAFILE_SEAHUB_ADMIN_EMAIL` email of admin account for seahub (web portal of seafile)
* `SEAFILE_SEAHUB_ADMIN_PASSWORD` password of above account

Some deployment variables:

* `SEAFILE_ROOT` seafile root directory path in the container
* `SEAFILE_ARCHIVE` seafile tarballs archieve directory path in the container
* `SEAFILE_HOST_MARIADB_ROOT` host path of mariadb root directory, mapped into container for both conf and data.
* `SEAFILE_HOST_WORKDIR` host path of seafile work directory, mapped into container for seafile conf and data.
* `SEAFILE_DOCKER_NETWORK_SUBNET` subnet the service uses.
* `SEAFILE_SERVER_IPV4_ADDR` address of seahub web portal as exposed to host.
* `SEAFILE_SEAHUB_SERVER_PORT` port of seahub web portal as exposed to host.


## Debugging

### Start up only mariadb

```bash
docker-compose up -d mariadb
```

### Check mariadb availability

```bash
docker run \
    -it --rm \
    --link seafile-mariadb \
    --network seafile_net \
    --env-file .env \
    mariadb \
    sh -c 'mysql -uroot -h${SEAFILE_MARIADB_HOST} -P3306 -p${SEAFILE_MARIADB_ROOT_PASSWORD}'
```
