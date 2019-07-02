# frozen_string_literal: true
Rails.application.routes.draw do
  root to: 'pages#dashboard'

  get '/success', to: 'pages#success', as: :success

  namespace :oauth do
    get 'slack', to: 'slack#code_grant'
    get 'discord', to: 'discord#code_grant'
  end
end
