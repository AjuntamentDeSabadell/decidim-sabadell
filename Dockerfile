FROM decidim/decidim:0.19.0-deploy
RUN apt-get install -y postgresql-client cron --fix-missing
