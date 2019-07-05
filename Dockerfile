FROM decidim/decidim:0.17.2-deploy
RUN apt-get install -y postgresql-client cron
