#!/bin/bash
./wait-for-postgres.sh $POSTGRES_HOST
bundle exec rake db:create &> /dev/null
bundle exec rake db:migrate assets:precompile && bundle exec passenger start
