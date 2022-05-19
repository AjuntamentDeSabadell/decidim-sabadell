FROM decidim/decidim:0.23.1-deploy
RUN apt-get --allow-releaseinfo-change update
RUN apt-get install -y postgresql-client cron --fix-missing
