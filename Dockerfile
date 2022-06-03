FROM decidim/decidim:0.23.1

COPY Gemfile Gemfile.lock ./
RUN bundle install
RUN rm -rf /code/db/migrate
COPY . .
RUN bundle install
RUN bundle exec rake assets:precompile

RUN apt-get --allow-releaseinfo-change update
RUN apt-get install -y postgresql-client cron --fix-missing
