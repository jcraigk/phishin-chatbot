# frozen_string_literal: true
Rails.application.routes.draw do
  root to: 'dashboard#index'

  namespace :oauth do
    get 'callbacks/slack', to: 'callbacks#slack'
  end
end
