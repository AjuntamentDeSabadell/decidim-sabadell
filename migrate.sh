#!/bin/bash
./wait-for-postgres.sh
bundle exec rake db:migrate assets:precompile
curl -i -u sabadell:$DOCKER_CLOUD_API_KEY -X POST -H "Accept: application/json" "https://cloud.docker.com/api/app/v1/service/$APP_SERVICE_ID/redeploy/"
