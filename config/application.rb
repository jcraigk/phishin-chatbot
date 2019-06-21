# frozen_string_literal: true
require_relative 'boot'

require 'rails'
require 'action_controller/railtie'
require 'action_view/railtie'

Bundler.require(*Rails.groups)

module Chatbot
  class Application < Rails::Application
    config.load_defaults 5.2
    config.api_only = true
  end
end
