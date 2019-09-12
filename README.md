# RAPiDSkills

The RAPiDSkills API is a Ruby on Rails
application hosted on Heroku.  It is written using Ruby 2.6.3
and Rails 6.0.  Postgres 11.5 is used for the database.

## Development setup
The following commands should just be run for the initial setup only. Rebuilding the docker images is only necessary when upgrading or if there are changes to the Dockerfile.
1. Install [Docker Community Edition](https://docs.docker.com/install/) if it
   is not already installed.
1. Clone the repository.
2. Copy `config/database.yml.example` to `config/database.yml`.
2. Copy `config/docker.env.example` to `config/docker.env`. It is not necessary to change any of the values.
3. Run `docker-compose build` to build images for all services.
4. Run `docker-compose up -d database` to start the database service.
4. Run `docker-compose run --rm web rails db:reset` to create the dev and test databases, and to run any migrations.
4. Run `docker-compose up -d` to start all the remaining services.
5. The web application will be available at http://localhost:3000

For ongoing development:
1. Run `docker-compose up -d` to start all services.
1. Run `docker-compose stop` to stop all services.
4. Run `docker-compose down -v` to stop and remove all containers, as well as volumes and networks. This command is helpful if you want to start with a clean slate.  However, you will need to go through the database setup steps again above.

### Viewing logs
To view the logs, run:
```
docker-compose logs -f <service>
```

For example:
```
docker-compose logs -f web
```

### Accessing services
To access the postgres database:
```
$ docker-compose exec database psql -h database -Upostgres rapidskills_development
```
Enter password when prompted (use `POSTGRES_PASSWORD` environment variable in `config/docker.env`).

To run the rails console:
```
$ docker-compose exec web rails c
```
