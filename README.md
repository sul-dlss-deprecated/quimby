[![Build Status](https://travis-ci.org/sul-dlss/quimby.svg?branch=master)](https://travis-ci.org/sul-dlss/quimby) | [![Coverage Status](https://coveralls.io/repos/github/sul-dlss/quimby/badge.svg?branch=master)](https://coveralls.io/github/sul-dlss/quimby?branch=master)

# Quimby

URL for SUL production instance:

Quimby is an infrastructure operations big picture reporting tool. It is a rails application that generates a dashboard. The dashboard presents information on servers, codebases, and analytics we can gather on the first two, for projects within SUL-DLSS and SUL-CIDR.

## Requirements

This is more what the application was built with; uncertain if older versions will / could work.

1. Ruby (2.4.1)
2. Rails (5.1.1 or greater)
3. Postgres

## Installation / Local Setup

Clone the repository

```bash
$ git clone git@github.com:sul-dlss/quimby.git
```

Change directories into the app and install dependencies

```bash
$ bundle install
```

Create the database for the Quimby application, then migrate the schema (if needed).

```bash
$ bundle exec rake db:create
$ bundle exec rake db:migrate
```

Now, you want to load your data. You need to add configuration information to `config/settings.yml` (see **Configuration** below for what is required), then run the rake task to load all data.

```bash
# after editing config/settings.yml
$ bundle exec rake load_data:all
```

This will load data from the Quimby data sources into the application database.

Finally, start the local development server:

```bash
$ bundle exec rails s
```

### Configuration

For each data source, you are required to have some configuration for access (captured in `config/settings.yml`). For this instance of the Quimby codebase, if you want to run the `load_data:all` rake task, you need the following configurations:

- the `PUPPETDB_ENDPOINT` for making puppetdb API calls
- an `GITHUB_OAUTH_TOKEN` that allows access to the SUL-DLSS and SUL-CIDR GitHub organizations (you only need a token that allows read repository rights)
- a `HONEYBADGER_API_TOKEN` that allows you to pull project information from Honeybadger for SUL projects
- a `GEMNASIUM_API_TOKEN` that allows you to pull Gemnasium information from the SUL Organization user in Gemnasium

## Testing

Quimby uses rspec for managing tests and factory girl for generating some of our fixtures class instances. To run tests:

```bash
$ bundle exec rake
```

## Deployment

Quimby uses capistrano to deploy. Current it's deployed to a staging machine named `sul-quimby-stage` and deployed via:

```bash
$ bundle exec cap stage deploy
```

## Data Sources

- **PuppetDB**:
  - PuppetDB is where we pull information about our servers.
  - For each server available via the PuppetDB API:
    - we retrieve all available FQDNs / domain names
    - we retrieve the IP Address via the PuppetDB API Facts endpoint by passing in fqdns
    - and we check if a server is pupgraded
- **GitHub Organizations**
  - A list of all repostories retrieved from the SUL-DLSS and SUL-CIDR GH Organizations
  - For each repository retrieved from GitHub:
    - Environments for a codebase where `config/deploy/ENV.rb` exist
    - Servers by looking for match to `[a-z0-9-]+.stanford.edu/` in each environment config file
    - Check for Capistrano if a `Capfile` exists in the repository
    - Check for Travis usage if a file ending with `.travis.yml` exists in the repository
    - Check for OKComputer usage if `config/initializers/okcomputer.rb` exists in the repository
    - Check for is_it_working usage if `config/initializers/is_it_working.rb` exists in the repository
    - Check for Honeybadger usage if `honeybadger` is in the Gemfile in the repository
    - Check for Honeybadger being deployed if `capistrano/honeybadger` in the `Capfile`
    - Check for Coveralls usage if `coveralls` is in the Gemfile in the repository
    - Check for Rails usage if `rails` is in the Gemfile in the repository
    - Check for Gemfile data in the repository files is `gemspec` exists somewhere in the repository
    - And if a repository that Quimby captured before is no longer returned from the GH API, we mark it as `current: FALSE`
- **Honeybadger**
  - By looking at each GH repository for the presence of a Honeybadger file, capture if a codebase is monitored or not
  - By calling the Honeybadger API, retrieve our Honeybadger project names and IDs
- **Gemnasium**
  - All gemanisum projects, and for each project (available via the API call), alert counts.
- **VMWare API**
  - To be written up
