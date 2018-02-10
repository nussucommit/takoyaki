# takoyaki
NUSSU commIT Duty Website, iteration 4

[![Build Status](https://travis-ci.org/commit-tech/takoyaki.svg?branch=master)](https://travis-ci.org/commit-tech/takoyaki)

## Entity-Relationship Diagram
![ERD](schema.png)

### Generate ERD
To generate the current Entity-Relationship Diagram, install `graphviz` (`sudo apt install graphfiz` or `brew install graphfiz`),
then run `rake generate_erd`. This is also run as a post-migration hook

