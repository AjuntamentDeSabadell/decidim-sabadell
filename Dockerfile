FROM decidim/decidim:0.17.1-deploy
RUN apt-get install -y postgresql-client cron
