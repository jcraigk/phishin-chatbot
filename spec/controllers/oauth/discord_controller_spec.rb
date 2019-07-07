# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Oauth::DiscordController, type: :request do
  include Rack::Test::Methods
  include Rails.application.routes.url_helpers

  describe 'GET /oauth/discord' do
    subject(:response) { get(path, params) }

    let(:access_token) { 'sometoken' }
    let(:code) { 'oauthcodexyz' }
    let(:expires_in) { 86_400 }
    let(:guild_id) { '123' }
    let(:guild_name) { 'Cool Guild' }
    let(:mock_http_post) { instance_spy(HTTP) }
    let(:oauth_url) { 'https://discordapp.com/api/v6/oauth2/token' }
    let(:params) { { code: code } }
    let(:path) { '/oauth/discord' }
    let(:refresh_token) { 'somerefreshtoken' }
    let(:token_expires_at) { Time.current + expires_in.to_i.seconds }
    let(:oauth_params) do
      {
        'client_id': ENV['DISCORD_CLIENT_ID'],
        'client_secret': ENV['DISCORD_CLIENT_SECRET'],
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': ENV['DISCORD_REDIRECT_URI'],
        'scope': 'bot'
      }
    end
    let(:oauth_response) do
      {
        guild: {
          id: guild_id,
          name: guild_name
        },
        access_token: access_token,
        expires_in: expires_in,
        refresh_token: refresh_token
      }.to_json
    end
    let(:registration_args) do
      {
        platform: :discord,
        id: guild_id,
        name: guild_name,
        token: access_token,
        token_expires_at: token_expires_at,
        refresh_token: refresh_token
      }
    end
    let(:redirect_path) { success_path(platform: :discord, team: guild_name) }

    before do
      Timecop.freeze
      allow(HTTP).to receive(:post).with(oauth_url, form: oauth_params).and_return(oauth_response)
      allow(TeamRegistrar).to receive(:call)
    end

    after { Timecop.return }

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
