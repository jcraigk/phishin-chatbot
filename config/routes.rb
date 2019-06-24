# frozen_string_literal: true
Rails.application.routes.draw do
  root to: 'dashboard#index'

  namespace :api do
    namespace :v1 do
      post 'slack_event' => 'slack#event'
    end
  end
end
