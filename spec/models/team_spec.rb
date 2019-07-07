# frozen_string_literal: true
require 'rails_helper'

describe Team do
  subject(:team) { build(:team) }

  it { is_expected.to be_a(ApplicationRecord) }

  it { is_expected.to validate_presence_of(:remote_id) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:remote_id).scoped_to(:platform) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:platform) }

  describe '#disable' do
    before { team.disable }

    it 'sets active to false' do
      expect(team.active?).to eq(false)
    end
  end

  describe 'chat platform connection lifecycle hooks' do
    context 'with Slack' do
      let(:platform) { :slack }

      before do
        allow(SocketManager).to receive(:add)
        allow(SocketManager).to receive(:remove)
      end

      shared_examples 'opens websocket' do
        it 'calls SocketManager#add' do
          expect(SocketManager).to have_received(:add).with(team)
        end
      end

      shared_examples 'closes websocket' do
        it 'calls SocketManager#remove' do
          expect(SocketManager).to have_received(:remove).with(team)
        end
      end

      context 'when creating' do
        subject(:team) { build(:team, platform: platform) }

        before { team.save }

        include_examples 'opens websocket'
      end

      describe 'when updating' do
        subject(:team) { create(:team, platform: platform) }

        context 'when active is not changed' do
          before { team.update(name: 'New name') }

          it 'does not call SocketManager#remove' do
            expect(SocketManager).not_to have_received(:remove)
          end
        end

        context 'when active is changed to true' do
          before { team.update(active: true) }

          include_examples 'opens websocket'
        end

        context 'when active is changed to false' do
          before { team.disable }

          include_examples 'closes websocket'
        end
      end

      describe 'when destroying' do
        subject(:team) { create(:team, platform: platform) }

        before { team.destroy }

        include_examples 'closes websocket'
      end
    end

    # Adding guilds is handled automatically through OAuth / Gateway connection
    # so we handle only removal
    context 'with Discord' do
      let(:platform) { :discord }

      before do
        allow(HTTP).to receive(:auth).with("Bot #{ENV['DISCORD_BOT_TOKEN']}").and_return(HTTP)
        allow(HTTP).to receive(:delete)
      end

      shared_examples 'leaves guild' do
        let(:leave_guild_url) { "https://discordapp.com/api/v6/users/@me/guilds/#{team.remote_id}" }

        it 'calls API to leave guild' do
          expect(HTTP).to have_received(:delete).with(leave_guild_url)
        end
      end

      describe 'when updating' do
        subject(:team) { create(:team, platform: platform) }

        context 'when active is changed to false' do
          before { team.disable }

          include_examples 'leaves guild'
        end
      end

      describe 'when destroying' do
        subject(:team) { create(:team, platform: platform) }

        before { team.destroy }

        include_examples 'leaves guild'
      end
    end
  end

  describe 'last event time tracking' do
    subject(:team) { create(:team) }

    let(:timestamp_key) { "#{team.platform}/#{team.remote_id}" }

    before { Timecop.freeze }

    after { Timecop.return }

    describe '#register_event' do
      before do
        allow(Timestamper).to receive(:register)
        team.register_event
      end

      it 'calls Timestamper#register' do
        expect(Timestamper).to have_received(:register).with(team.platform, team.remote_id)
      end
    end

    describe '#last_event_at' do
      before do
        allow(Timestamper).to receive(:lookup).and_return(Time.current)
      end

      it 'calls RedisClient#get' do
        expect(team.last_event_at).to eq(Time.current)
      end
    end
  end
end
