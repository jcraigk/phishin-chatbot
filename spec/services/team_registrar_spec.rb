# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TeamRegistrar do
  subject(:service) { described_class.new(opts) }

  let(:opts) do
    {
      platform: team.platform,
      id: team.remote_id,
      name: team.name,
      bot_user_id: team.bot_user_id,
      token: team.token
    }
  end

  context 'when team already exists' do
    let!(:team) { create(:team) }
    let(:expected_attrs) do
      {
        bot_user_id: team.bot_user_id,
        token: team.token,
        active: true
      }
    end

    before do
      allow(Team).to(
        receive(:find_by).with(platform: team.platform, remote_id: team.remote_id).and_return(team)
      )
      allow(team).to receive(:update)
      service.call
    end

    it 'updates the existing team' do
      expect(team).to have_received(:update).with(expected_attrs)
    end
  end

  context 'when team does not exist' do
    let(:team) { build(:team) }
    let(:expected_attrs) do
      {
        bot_user_id: team.bot_user_id,
        token: team.token,
        platform: team.platform,
        remote_id: team.remote_id,
        name: team.name
      }
    end

    before do
      allow(Team).to receive(:create!)
      service.call
    end

    it 'creates the team' do
      expect(Team).to have_received(:create!).with(expected_attrs)
    end
  end
end
