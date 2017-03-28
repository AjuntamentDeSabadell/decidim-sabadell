#!/bin/bash
./wait-for-postgres.sh
bundle exec rake db:create &> /dev/null
bundle exec rake db:migrate assets:precompile && bundle exec passenger start
