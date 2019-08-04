# frozen_string_literal: true
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'async-websocket', '~> 0.8.0' # https://github.com/slack-ruby/slack-ruby-client/issues/272
gem 'discordrb'
gem 'font-awesome-rails'
gem 'http'
gem 'pg'
gem 'puma'
gem 'rails'
gem 'redis'
gem 'sass-rails'
gem 'sentry-raven'
gem 'slack-ruby-client'
gem 'slim'

group :development do
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :development, :test do
  gem 'awesome_print'
  gem 'codecov', require: false
  gem 'dotenv-rails'
  gem 'pry-rails'
  gem 'simplecov', require: false
end

group :test do
  gem 'capybara', require: false
  gem 'capybara-screenshot', require: false
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'vcr'
  gem 'webmock'
end
