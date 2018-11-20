FROM decidim/decidim:0.15.0-deploy
RUN apt-get install -y postgresql-client cron
