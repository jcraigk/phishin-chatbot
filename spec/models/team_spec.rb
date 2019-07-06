# frozen_string_literal: true
require 'rails_helper'

describe Team do
  subject(:team) { build(:team) }

  it { is_expected.to be_a(ApplicationRecord) }

  it { is_expected.to validate_presence_of(:remote_id) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:token) }
  it { is_expected.to validate_uniqueness_of(:remote_id).scoped_to(:platform) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:platform) }
  it { is_expected.to validate_uniqueness_of(:token).scoped_to(:platform) }

  describe 'websocket lifecycle hooks' do
    before do
      allow(SocketManager).to receive(:add)
      allow(SocketManager).to receive(:remove)
    end

    context 'when creating' do
      before { team.save }

      it 'calls SocketManager.add(self)' do
        expect(SocketManager).to have_received(:add).with(team)
      end
    end

    describe 'when updating' do
      subject(:team) { create(:team) }

      context 'when active is not changed' do
        before { team.update(name: 'New name') }

        it 'does not call SocketManager#remove' do
          expect(SocketManager).not_to have_received(:remove)
        end
      end

      context 'when active is changed to false' do
        before { team.update(name: Faker::Name.unique.name, active: false) }

        it 'calls SocketManager#remove' do
          expect(SocketManager).to have_received(:remove).with(team)
        end
      end
    end

    describe 'when destroying' do
      subject(:team) { create(:team) }

      before { team.destroy }

      it 'calls SocketManager#remove' do
        expect(SocketManager).to have_received(:remove).with(team)
      end
    end
  end

  describe 'last event time tracking' do
    subject(:team) { create(:team) }

    let(:timestamp_key) { "last_events/#{team.id}" }

    before { Timecop.freeze }

    after { Timecop.return }

    describe '#register_event' do
      before do
        allow(RedisClient).to receive(:set)
        team.register_event
      end

      it 'calls RedisClient#set' do
        expect(RedisClient).to have_received(:set).with(timestamp_key, Time.current.to_i)
      end
    end

    describe '#last_event_at' do
      before do
        allow(RedisClient).to receive(:get)
        team.last_event_at
      end

      it 'calls RedisClient#get' do
        expect(RedisClient).to have_received(:get).with(timestamp_key)
      end
    end
  end
end
