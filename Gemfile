# frozen_string_literal: true
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'bulma-rails'
gem 'http'
gem 'puma'
gem 'rails'
gem 'sass-rails'
gem 'sentry-raven'
gem 'slim'

group :development do
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :development, :test do
  gem 'awesome_print'
  gem 'dotenv-rails'
  gem 'pry-rails'
end

group :test do
  gem 'rspec-rails'
  gem 'simplecov', require: false
end
