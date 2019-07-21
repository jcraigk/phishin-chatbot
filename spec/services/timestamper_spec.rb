# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Timestamper do
  subject(:service) { described_class }

  let(:platform) { 'slack' }
  let(:id) { 1 }

  describe '.register' do
    before do
      allow(RedisClient).to receive(:set)
      service.register(platform, id)
    end

    it 'calls RedisClient.set' do
      expect(RedisClient).to(
        have_received(:set).with("timestamps/#{platform}/#{id}", Time.current.to_i)
      )
    end
  end

  describe '.lookup' do
    before do
      allow(RedisClient).to receive(:get)
      service.lookup(platform, id)
    end

    it 'calls RedisClient.get' do
      expect(RedisClient).to(
        have_received(:get).with("timestamps/#{platform}/#{id}")
      )
    end
  end
end
