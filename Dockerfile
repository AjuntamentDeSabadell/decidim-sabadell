FROM decidim/decidim:0.22.0-deploy
RUN apt-get update
RUN apt-get install -y postgresql-client cron --fix-missing
