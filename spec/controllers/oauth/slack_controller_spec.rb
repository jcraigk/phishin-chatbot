# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Oauth::SlackController, type: :request do
  include Rack::Test::Methods
  include Rails.application.routes.url_helpers

  describe 'GET /oauth/slack' do
    subject(:response) { get(path, params) }

    let(:access_token) { 'sometoken' }
    let(:code) { 'oauthcodexyz' }
    let(:team_id) { '123' }
    let(:bot_user_id) { 'somebot-id' }
    let(:team_name) { 'Cool Team' }
    let(:params) { { code: code } }
    let(:path) { '/oauth/slack' }
    let(:oauth_params) do
      {
        client_id: ENV['SLACK_CLIENT_ID'],
        client_secret: ENV['SLACK_CLIENT_SECRET'],
        code: code,
        redirect_uri: ENV['SLACK_REDIRECT_URI']
      }
    end
    let(:oauth_response) do
      {
        bot: {
          bot_user_id: bot_user_id,
          bot_access_token: access_token
        },
        team_id: team_id,
        team_name: team_name
      }
    end
    let(:registration_args) do
      {
        platform: :slack,
        id: team_id,
        name: team_name,
        bot_user_id: bot_user_id,
        token: access_token
      }
    end
    let(:redirect_path) { success_path(platform: :slack, team: team_name) }
    let(:slack_client) { instance_spy(Slack::Web::Client) }

    before do
      allow(Slack::Web::Client).to receive(:new).and_return(slack_client)
      allow(slack_client).to receive(:oauth_access).with(oauth_params).and_return(oauth_response)
      allow(TeamRegistrar).to receive(:call)
    end

    it 'returns 302' do
      expect(response.status).to eq(302)
    end

    it 'redirects to success path' do
      expect(response.headers['Location']).to include(redirect_path)
    end

    it 'calls TeamRegistrar with expected args' do
      response
      expect(TeamRegistrar).to have_received(:call).with(registration_args)
    end
  end
end
