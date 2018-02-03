#!/bin/bash

cd ${SEAFILE_ROOT}/seafile-server-latest
# Stop seahub service
./seahub.sh stop

# Stop seafile service
./seafile.sh stop
