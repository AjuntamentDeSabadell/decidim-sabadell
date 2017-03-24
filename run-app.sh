#!/bin/bash
bundle exec rake db:migrate assets:precompile && bundle exec passenger start
