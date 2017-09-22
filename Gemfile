source "https://rubygems.org"

ruby '2.4.2'

gem "decidim", "~> 0.6.4"

gem 'puma'
gem 'uglifier'

group :development, :test do
  gem 'byebug', platform: :mri
  gem "decidim-dev"
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
end

group :test do
  gem "rspec-rails"
  gem "database_cleaner"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
