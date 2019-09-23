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
4. Run `docker-compose run --rm web rails db:reset` to create the dev and test databases, load the schema, and run the seeds file.
4. Run `docker-compose up -d` to start all the remaining services.
5. The web application will be available at http://localhost:3000

For ongoing development:
1. Run `docker-compose up -d` to start all services.
1. Run `docker-compose stop` to stop all services.
1. Run `docker-compose restart web` to restart the web server.
4. Run `docker-compose down -v` to stop and remove all containers, as well as volumes and networks. This command is helpful if you want to start with a clean slate.  However, you will need to go through the database setup steps again above.

### Running commands
In order to run rake tasks, rails generators, bundle commands, etc., they need to be run inside the container:
```
docker-compose exec web rails db:migrate
```

If you do not have the web container running, you can run a command in a one-off container:

```
docker-compose run --rm web bundle install
```

However, when using a one-off container, make sure the image is up-to-date by
running `docker-compose build web` first.  If you have been making gem updates
to your container without rebuilding the image, for example, then the one-off
container will be out of date.

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

## Mailcatcher
We use [Mailcatcher](https://mailcatcher.me/) to receive mail in development.
All mail sent in the development environment can be viewed at http://localhost:1080.

## Secret keys
To edit the encrypted credentials for staging and production, you must have the
master key files stored in `config/credentials/staging.key` and
`config/credentials/production.key`.

To edit:

```
$ docker-compose run --rm -e EDITOR=vim web rails credentials:edit --environment <environment>
```

For example:

```
$ docker-compose run --rm -e EDITOR=vim web rails credentials:edit --environment staging
```

## Testing Suite

We are using [RSpec](http://rspec.info/) for tests.  Before beginning a new
feature, please run the specs and make sure the entire test suite is passing.
All tests should be passing when submitting a PR.  Please write specs as
appropriate.

To run all specs:

```
$ docker-compose exec web rspec spec -fd
```

To run an individual file:

```
$ docker-compose exec web rspec spec/models/user_spec.rb -fd
```

To run an individual spec, pass the spec name or partial match:
```
$ docker-compose exec web rspec spec/models/user_spec.rb -fd -e "valid factory"
```

Individual specs can also be run by specifying the line number:

```
$ docker-compose exec web rspec spec/models/user_spec.rb:4 -fd
```
