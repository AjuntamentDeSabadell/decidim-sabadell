# decidim-sabadell

[![CircleCI](https://circleci.com/gh/AjuntamentDeSabadell/decidim-sabadell.svg?style=svg)](https://circleci.com/gh/AjuntamentDeSabadell/decidim-sabadell)
[![Docker Hub](https://img.shields.io/docker/build/ajsabadell/decidim-sabadell.svg)](https://hub.docker.com/r/ajsabadell/decidim-sabadell)

---

Citizen Participation and Open Government Application

This is the opensource code repository for "decidim-sabadell", based on [Decidim](https://github.com/decidim/decidim).

## Development environment setup

You can setup everything with Docker & Docker compose, run:

As a one time thing, you first need to initialize the Docker swarm with:

```
docker swarm init
```

Then, since we're using a different Docker image for development, you need to build the image and deploy the stack:

```
docker build . -t ajsabadell/decidim-sabadell:dev -f Dockerfile.dev
docker stack deploy --compose-file docker-compose.dev.yml decidim-sabadell
```
You can access to decidim through `localhost` in your browser.

If you need to run a rails command, you can do it like this:

```
docker exec -it `docker ps | grep decidim-sabadell_app-worker | awk '{print $1}'` bundle exec rake db:create
docker exec -it `docker ps | grep decidim-sabadell_app-worker | awk '{print $1}'` bundle exec rake db:schema:load
docker exec -it `docker ps | grep decidim-sabadell_app-worker | awk '{print $1}'` bundle exec rake db:migrate
docker exec -it `docker ps | grep decidim-sabadell_app-worker | awk '{print $1}'` bundle exec rake db:seed
```

`docker ps | grep decidim-sabadell_app-worker | awk '{print $1}'` will get the ID of the first container 
running the service `decidim-sabadell_app-worker` and execute the given command inside it.


## Production environment setup

We're using [Docker Swarm](https://docs.docker.com/engine/swarm/) with [Docker Flow proxy](https://proxy.dockerflow.com) to deploy this application.

When seting up a new server, you should first install dependencies:

```
sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

sudo apt-get install docker-ce
```

Then, to make sure the default network Docker creates doesn't match a local IP range, we'll create our own:

First, we'll make sure there's no docker network created:

```
ip link set docker_gwbridge down
ip link del dev docker_gwbridge
```

Then, we'll create a new one:

```
docker network create --subnet 10.11.0.0/16 --opt com.docker.network.bridge.name=docker_gwbridge --opt com.docker.network.bridge.enable_icc=false --opt com.docker.network.bridge.enable_ip_masquerade=true docker_gwbridge
```

Now we're ready to install Decidim Sabadell:

```
mkdir -p /var/decidim/logs /var/decidim/uploads /var/decidim/certs /var/decidim/postgresql/data /var/decidim/backups
```

Move to the directory where you want to install the application:

```
git clone https://github.com/AjuntamentDeSabadell/decidim-sabadell.git /var/decidim/code
```

The next step is to configure the variables that Docker Compose needs:

```
cp /var/decidim/code/config.example /var/decidim/.config
```

Update the `.config` file with your favourite editor and set the values for each variable (blank values are OK)
and keep the last blank line so the script that update the Docker Compose yml work OK. Some hints:

1. `GEOCODER_LOOKUP_APP_ID` and `GEOCODER_LOOKUP_APP_CODE` are the API keys from [Here Maps](https://developer.here.com).
1. To generate a secret key base, you can do it with `docker run --rm ajsabadell/decidim-sabadell bundle exec rake secret`.

Then run `./update_docker_compose_config.sh /var/decidim/.config docker-compose.yml`

Finally, copy your pem certificates to `/var/decidim/certs`.

The last step is to init the Docker swarm and deploy it:

```
docker swarm init
docker stack deploy --compose-file docker-compose.yml decidim-sabadell
```

## Backups

There's a daily backup of the database at `/var/decidim/backups` with a maximum of 30 copies.

You should probably copy those to an external storage and also `/var/decidim/uploads`.

## Upgrading 

To upgrade this application you first need to build a new Docker image and then upgrade the deployment:

1. Create a new git branch, for example: `git checkout -b upgrade-to-decidim-N-version`
1. Change `DECIDIM_VERSION` at `Gemfile`
1. Change the `APPLICATION_VERSION` at `circle.yml` to match Decidim's version.
1. Run `bundle update decidim decidim-dev` 
1. Run `rake decidim:upgrade`
1. Run `rake db:migrate`
1. Commit and push the changes to the repository and create a new Pull Request.
1. After reviewing that everything works as expected you can merge the Pull Request, CircleCI will build and push the new Docker image.

Once the new image is pushed to Docker Hub, you can update the production deployment:

1. Update the `docker-compose.yml` file with the new image tag (lines 21 and 51).
1. Update the stack with `docker stack deploy --compose-file docker-compose.yml decidim-sabadell`.

If there are any pending migrations they will be executed automatically.

If you need to update the repository (when there's a change at the `docker-compose.yml` file for example),
you should first reset it (any uncommited changes will be lost):

```
git checkout .
git pull origin master
```

## Licence

Code published under AFFERO GPL v3 (see [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt))
