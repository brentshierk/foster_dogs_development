# foster-roster

excel sheets are awesome until they are not. foster roster serves is an operational tool to keep track of fosters throughout their lifecycle.

### important things to note

Ruby on Rails 5 app

[Bootstrap](http://getbootstrap.com/docs/3.3/)/jQuery front-end

### quick install
1. install a version manager `$ brew install rbenv`
2. install dependencies: postgres, elasticsearch, redis-server
3. clone the repository
4. navigate to project root
5. `rvm install [current ruby version]` (check .ruby-version)
6. `rake db:setup`
7. `bundle install`
8. copy the .env file `cp .env-template .env`
9. fill in `ADMIN_USERNAME` and `ADMIN_PASSWORD` (for GOOGLE_MAPS_KEY and ROLLBAR_ACCESS_TOKEN check with Kevin or check Heroku)
10. `rails s` should boot your server
11. navigate to `localhost:3000` and enter your username and password and you should be g2g


### Docker
1. Make sure you have [docker](https://docs.docker.com/install/#supported-platforms) installed
2. From the project root:
3. `make install`
4. `make setup-db`
5. fill in any required env vars in `.env` (same as above)
6. app will be up at `localhost:3000`
7. For additional commands: `make help`

### Dumping from Production to local
```
heroku pg:backups:capture && heroku pg:backups:download && pg_restore --verbose --clean --no-acl --no-owner -h localhost -d foster-roster_development latest.dump && rake db:environment:set RAILS_ENV=development
```
