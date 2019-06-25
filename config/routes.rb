# frozen_string_literal: true
Rails.application.routes.draw do
  root to: 'dashboard#index'

  post 'slack_event' => 'slack_callback#event'
end
