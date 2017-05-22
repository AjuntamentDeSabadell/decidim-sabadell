source "https://rubygems.org"

ruby '2.4.1'

gem "decidim"

gem 'puma', '~> 3.0'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug', platform: :mri
  gem "decidim-dev"
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.1.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'faker', '~> 1.7.3'
end

group :production do
  gem "passenger"
  gem "rails_12factor"
  gem 'dalli'
  gem 'sidekiq'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
