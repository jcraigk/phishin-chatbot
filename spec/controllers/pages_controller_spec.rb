# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PagesController, type: :request do
  include Rack::Test::Methods

  describe 'GET /' do
    subject(:response) { get('/') }

    it { is_expected.to be_successful }

    it 'returns expected title' do
      expect(response.body).to include('<title>Phish.in Chatbot</title>')
    end
  end

  describe 'GET /success' do
    subject(:response) { get('/success', platform: :slack, team: 'Cool Team') }

    it { is_expected.to be_successful }

    it 'returns expected content' do
      expect(response.body).to include('The bot is now available to the <strong>Slack</strong> team <strong>Cool Team</strong>')
    end
  end
end
