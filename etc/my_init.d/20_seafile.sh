#!/bin/bash

cd ${SEAFILE_ROOT}/seafile-server-latest
# Start seafile service
if ! ./seafile.sh start; then
    exit -1
fi

# Start seahub service
if ! ./seahub.sh start ${SEAFILE_SEAHUB_SERVER_PORT}; then
    exit -1
fi

