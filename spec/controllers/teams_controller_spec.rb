# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TeamsController, type: :request do
  include Rack::Test::Methods

  describe 'POST /teams/purge_inactive', :freeze_time do
    subject(:response) { post('/teams/purge_inactive') }

    let(:inactive_team) { create(:team) }
    let(:active_team) { create(:team) }

    before do
      allow(inactive_team).to receive(:last_event_at).and_return(Time.current - 1.month.ago)
      allow(active_team).to receive(:last_event_at).and_return(Time.current - 1.minute.ago)
      response
    end

    it { expect(response.status).to eq(204) }

    it 'deactivates inactive team' do
      expect(inactive_team.reload.active?).to eq(false)
    end
  end
end
