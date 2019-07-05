FROM decidim/decidim:0.18.0-deploy
RUN apt-get install -y postgresql-client cron
