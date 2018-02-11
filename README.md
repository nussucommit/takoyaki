# takoyaki
NUSSU commIT Duty Website, iteration 4

[![Build Status](https://travis-ci.org/commit-tech/takoyaki.svg?branch=master)](https://travis-ci.org/commit-tech/takoyaki)

## Entity-Relationship Diagram
![ERD](schema.png)

### Generate ERD
To generate the current Entity-Relationship Diagram, install `graphviz` (`sudo apt install graphviz` or `brew install graphviz`),
then run `rake generate_erd`. This is also run as a post-migration hook (i.e. after `bin/rails db:migrate`)

## Installation
Make sure you have Ruby 2.5.0 and PostgreSQL 9.6 installed
```bash
cp config/database.yml.example config/database.yml
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
```
