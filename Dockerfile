FROM phusion/baseimage

RUN apt update && apt-get install -y \
        python2.7 libpython2.7 python-setuptools \
        python-imaging python-ldap python-mysqldb \
        python-memcache python-urllib3

COPY sbin/  /sbin
COPY etc/   /etc

ARG SEAFILE_ROOT
ARG SEAFILE_ARCHIVE
ARG SEAFILE_MARIADB_HOST
ARG SEAFILE_MARIADB_PORT

ENV SEAFILE_ROOT=${SEAFILE_ROOT} \
    SEAFILE_ARCHIVE=${SEAFILE_ARCHIVE} \
    SEAFILE_MARIADB_HOST=${SEAFILE_MARIADB_HOST} \
    SEAFILE_MARIADB_PORT=${SEAFILE_MARIADB_PORT} \
    SEAFILE_DATA_PATH=${SEAFILE_ROOT}/seafile-data

RUN mkdir -p ${SEAFILE_ROOT}
COPY archive/ ${SEAFILE_ARCHIVE}

# Use baseimage-docker's init system.
ENV ENTRYPOINT="/sbin/my_init"

# seafile.init.sh will execute ${ENTRYPOINT} after image initialization
ENTRYPOINT wait-for-it.sh -t 60 \
    ${SEAFILE_MARIADB_HOST}:${SEAFILE_MARIADB_PORT} \
    -- seafile.init.sh
