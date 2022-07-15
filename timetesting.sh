#!/bin/bash

export PGPASSWORD='postgres'

docker stop test
docker rm test
docker run --name test -d -p 2022:5432 -v $PWD/out:/out -e POSTGRES_PASSWORD=postgres sedv8808/neotoma_postgres postgres

my_command () { psql -h localhost -p 2022 -U postgres -d neotoma -c 'SELECT * FROM ndb.agetypes'; }

start=$SECONDS

until my_command; do
    echo test
    # potentially, other code follows...
done

duration=$(( SECONDS - start ))

echo ${duration} >> timer.txt