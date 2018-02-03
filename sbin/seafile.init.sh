#!/bin/bash

check_initailization_variables() {
    if [ -z $SEAFILE_ROOT ]; then
        echo "SEAFILE_ROOT not set"
        exit -1
    fi

    if [ -z $SEAFILE_ARCHIVE ]; then
        echo "SEAFILE_ARCHIVE not set"
        exit -1
    fi

    if [ -z $SEAFILE_SERVER_TARBALL ]; then
        echo "SEAFILE_SERVER_TARBALL not set"
        exit -1
    fi

    if [ -z $SEAFILE_SERVER_DIRNAME ]; then
        echo "SEAFILE_SERVER_DIRNAME not set"
        exit -1
    fi

    # Basic server initialization configs
    if [ -z $SEAFILE_SERVER_NAME ]; then
        echo "SEAFILE_SERVER_NAME not set"
        exit -1
    fi

    if [ -z $SEAFILE_SERVER_HOST ]; then
        echo "SEAFILE_SERVER_HOST not set"
        exit -1
    fi

    if [ -z $SEAFILE_SERVER_PORT ]; then
        echo "SEAFILE_SERVER_PORT not set"
        exit -1
    fi

    if [ -z $SEAFILE_DATA_PATH ]; then
        echo "SEAFILE_DATA_PATH not set"
        exit -1
    fi

    if [ -z $SEAFILE_INIT_DATABASE ]; then
        echo "SEAFILE_INIT_DATABASE not set"
        exit -1
    fi

    if [ -z $SEAFILE_MARIADB_HOST ]; then
        echo "SEAFILE_MARIADB_HOST not set"
        exit -1
    fi

    if [ -z $SEAFILE_MARIADB_PORT ]; then
        echo "SEAFILE_MARIADB_PORT not set"
        exit -1
    fi

    if [ -z $SEAFILE_MARIADB_USER ]; then
        echo "SEAFILE_MARIADB_USER not set"
        exit -1
    fi

    if [ -z $SEAFILE_MARIADB_PASSWORD ]; then
        echo "SEAFILE_MARIADB_PASSWORD not set"
        exit -1
    fi

    if [ -z $SEAFILE_MARIADB_USER_HOST ]; then
        echo "SEAFILE_MARIADB_USER_HOST not set"
        exit -1
    fi

    if [ -z $SEAFILE_MARIADB_ROOT_PASSWORD ]; then
        echo "SEAFILE_MARIADB_ROOT_PASSWORD not set"
        exit -1
    fi

    if [ -z $SEAFILE_CCNET_DB_NAME ]; then
        echo "SEAFILE_CCNET_DB_NAME not set"
        exit -1
    fi

    if [ -z $SEAFILE_SEAFILE_DB_NAME ]; then
        echo "SEAFILE_SEAFILE_DB_NAME not set"
        exit -1
    fi

    if [ -z $SEAFILE_SEAHUB_DB_NAME ]; then
        echo "SEAFILE_SEAHUB_DB_NAME not set"
        exit -1
    fi

    if [ -z $SEAFILE_SEAHUB_ADMIN_EMAIL ]; then
        echo "SEAFILE_SEAHUB_ADMIN_EMAIL not set"
        exit -1
    fi

    if [ -z $SEAFILE_SEAHUB_ADMIN_PASSWORD ]; then
        echo "SEAFILE_SEAHUB_ADMIN_PASSWORD not set"
        exit -1
    fi

}

# detect if initialization is necessary
if [ ! -f ${SEAFILE_ROOT}/conf/seafile.conf ]; then

    check_initailization_variables

    # Initialize work directory
    mkdir -p ${SEAFILE_ROOT}
    cd  ${SEAFILE_ROOT}

    # Extract seafile server from tarball
    tar xf ${SEAFILE_ARCHIVE}/${SEAFILE_SERVER_TARBALL}

    # Initialize seafile
    cd ${SEAFILE_SERVER_DIRNAME}
    CMD="./setup-seafile-mysql.sh auto \
        --server-name ${SEAFILE_SERVER_NAME} \
        --server-ip ${SEAFILE_SERVER_HOST} \
        --fileserver-port ${SEAFILE_SERVER_PORT} \
        --seafile-dir ${SEAFILE_DATA_PATH} \
        --use-existing-db $(expr 1 - ${SEAFILE_INIT_DATABASE}) \
        --mysql-host ${SEAFILE_MARIADB_HOST} \
        --mysql-port ${SEAFILE_MARIADB_PORT} \
        --mysql-user ${SEAFILE_MARIADB_USER} \
        --mysql-user-passwd ${SEAFILE_MARIADB_PASSWORD} \
        --mysql-user-host ${SEAFILE_MARIADB_USER_HOST} \
        --mysql-root-passwd ${SEAFILE_MARIADB_ROOT_PASSWORD} \
        --ccnet-db ${SEAFILE_CCNET_DB_NAME} \
        --seafile-db ${SEAFILE_SEAFILE_DB_NAME} \
        --seahub-db ${SEAFILE_SEAHUB_DB_NAME} \
    "
    #echo $CMD
    if ! eval $CMD; then
        echo "Failed to initialize seafile"
        exit -1
    fi

    echo \
"{
  \"email\": \"${SEAFILE_SEAHUB_ADMIN_EMAIL}\",
  \"password\": \"${SEAFILE_SEAHUB_ADMIN_PASSWORD}\"
}" > ../conf/admin.txt

    ./seafile.sh start
    CMD="./seahub.sh python-env python check_init_admin.py"
    #echo $CMD
    if ! eval $CMD; then
        echo "Failed to initialize seahub admin account"
        ./seafile.sh stop
        exit -1
    fi
    ./seafile.sh stop
fi

exec ${ENTRYPOINT}
