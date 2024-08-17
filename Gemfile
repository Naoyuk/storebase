source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.4"
gem "bootsnap", require: false
gem "carrierwave"
gem "cssbundling-rails"
gem "devise"
gem "dotenv-rails"
gem "faker"
gem "jbuilder"
gem "jsbundling-rails"
gem "mini_magick"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem 'puma-daemon', require: false
gem "rails", "~> 7.0.4", ">= 7.0.4.3"
gem "redis", "~> 4.0"
gem 'sassc-rails'
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'capistrano', '~> 3.17.1'
  gem 'capistrano3-puma'
  gem 'capistrano-rails', '~> 1.2'
  gem 'capistrano-rbenv'
  gem 'capistrano-yarn'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :development do
  gem 'rubocop', '~> 1.27.0', require: false
  gem 'rubocop-performance', '~> 1.13.0', require: false
  gem 'rubocop-rails', '~> 2.13.0', require: false
  gem 'rubocop-rspec', '~> 2.8.0', require: false
  gem "web-console"
end

group :test do
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'selenium-webdriver'
  gem 'simplecov'
end
