# frozen_string_literal: true
require_relative 'boot'

require 'rails'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'active_record/railtie'

Bundler.require(*Rails.groups)

Dotenv::Railtie.load # Load dotenv values

module Chatbot
  class Application < Rails::Application
    config.load_defaults 5.2
    config.api_only = true

    # Custom config
    config.cache_ttl = 1.day
    config.inactive_seconds = 5_184_000

    config.hosts << 'chatbot.phish.in'
  end
end
