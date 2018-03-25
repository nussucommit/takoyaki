# takoyaki
NUSSU commIT Duty Website, iteration 4

[![Build Status](https://travis-ci.org/commit-tech/takoyaki.svg?branch=master)](https://travis-ci.org/commit-tech/takoyaki)
[![Coverage Status](https://coveralls.io/repos/github/commit-tech/takoyaki/badge.svg?branch=master)](https://coveralls.io/github/commit-tech/takoyaki?branch=master)

## Entity-Relationship Diagram
![ERD](schema.png)

### Generate ERD
To generate the current Entity-Relationship Diagram, install `graphviz` (`sudo apt install graphviz` or `brew install graphviz`),
then run `rake generate_erd`. This is also run as a post-migration hook (i.e. after `bin/rails db:migrate`)

## Installation
Make sure you have Ruby 2.5.0, Bundler, and PostgreSQL 9.6 installed. Also, create an account on Mailgun for email services.
Adjust the content of `database.yml` and `.env`

```bash
cp config/database.yml.example config/database.yml
cp .env.default .env
bundle install
bin/rails db:setup
bin/rails server
```
