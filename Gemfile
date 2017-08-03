source "https://rubygems.org"

ruby '2.4.1'

gem "decidim"

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

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
