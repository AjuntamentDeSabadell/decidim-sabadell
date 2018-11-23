FROM decidim/decidim:0.15.1-deploy
RUN apt-get install -y postgresql-client cron
