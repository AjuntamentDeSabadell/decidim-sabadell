source "https://rubygems.org"

ruby '2.5.3'

DECIDIM_VERSION = "~> 0.14.4"

gem "decidim", DECIDIM_VERSION
gem "virtus-multiparams"

gem 'puma'
gem 'uglifier'

group :development, :test do
  gem 'byebug', platform: :mri
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'faker'
end

group :production do
  gem "passenger"
  gem "rails_12factor"
  gem 'dalli'
  gem 'sidekiq'
  gem "sentry-raven"
end

group :test do
  gem "rspec-rails"
  gem "database_cleaner"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
