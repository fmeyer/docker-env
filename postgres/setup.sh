#!/bin/bash

docker volume create --driver local --name=pgvolume
docker volume create --driver local --name=pga4volume

docker network create --driver bridge pgnetwork

cat << EOF > pg-env.list
PG_MODE=primary
PG_PRIMARY_USER=postgres
PG_PRIMARY_PASSWORD=postgres
PG_DATABASE=database
PG_USER=fm
PG_PASSWORD=password
PG_ROOT_PASSWORD=password
PG_PRIMARY_PORT=5432
EOF

cat << EOF > pgadmin-env.list
PGADMIN_SETUP_EMAIL=frnmeyer@gmail.com
PGADMIN_SETUP_PASSWORD=password
SERVER_PORT=5050
EOF

docker run --publish 5432:5432 \
  --volume=pgvolume:/pgdata \
  --env-file=pg-env.list \
  --name="postgres" \
  --hostname="postgres" \
  --network="pgnetwork" \
  --detach \
crunchydata/crunchy-postgres:centos7-10.1-1.7.1

docker run --publish 5050:5050 \
  --volume=pga4volume:/var/lib/pgadmin \
  --env-file=pgadmin-env.list \
  --name="pgadmin4" \
  --hostname="pgadmin4" \
  --network="pgnetwork" \
  --detach \
crunchydata/crunchy-pgadmin4:centos7-10.1-1.7.1

rm pg-env.list pgadmin-env.list
