#!/bin/bash

set -e

# This script copies the production database and imports it into the local
# development database.

heroku pg:backups:capture -a rapid-skills
heroku pg:backups:download -a rapid-skills
docker cp latest.dump rapidskills_database_1:.
docker-compose exec -T database bash -c 'PGPASSWORD=$POSTGRES_PASSWORD pg_restore --verbose --clean --no-acl --no-owner -w -h database -Upostgres -d rapidskills_development latest.dump && rm latest.dump'
docker-compose exec -T database bash -c "PGPASSWORD=$POSTGRES_PASSWORD psql -Upostgres rapidskills_development -c \"UPDATE ar_internal_metadata SET value='development' WHERE key='environment';\""
rm latest.dump
