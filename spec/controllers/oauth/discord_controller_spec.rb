# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Oauth::DiscordController, type: :request do
  include Rack::Test::Methods
  include Rails.application.routes.url_helpers

  describe 'GET /oauth/discord', :freeze_time do
    subject(:response) { get(path, params) }

    let(:code) { 'oauthcodexyz' }
    let(:guild_id) { '123' }
    let(:guild_name) { 'Cool Guild' }
    let(:mock_http_post) { instance_spy(HTTP) }
    let(:oauth_url) { 'https://discordapp.com/api/v6/oauth2/token' }
    let(:params) { { code: code } }
    let(:path) { '/oauth/discord' }
    let(:oauth_params) do
      {
        'client_id': ENV['DISCORD_CLIENT_ID'],
        'client_secret': ENV['DISCORD_CLIENT_SECRET'],
        'grant_type': 'authorization_code',
        'code': code,
        'scope': 'bot'
      }
    end
    let(:oauth_response) do
      {
        guild: {
          id: guild_id,
          name: guild_name
        }
      }.to_json
    end
    let(:registration_args) do
      {
        platform: :discord,
        id: guild_id,
        name: guild_name
      }
    end
    let(:redirect_path) { success_path(platform: :discord, team: guild_name) }

    before do
      allow(HTTP).to receive(:post).with(oauth_url, form: oauth_params).and_return(oauth_response)
      allow(TeamRegistrar).to receive(:call)
    end

    it 'returns 302' do
      expect(response.status).to eq(302)
    end

    it 'redirects to success path' do
      expect(response.headers['Location']).to include(redirect_path)
    end

    it 'calls TeamRegistrar with expected args', :freeze_time do
      response
      expect(TeamRegistrar).to have_received(:call).with(registration_args)
    end
  end
end
