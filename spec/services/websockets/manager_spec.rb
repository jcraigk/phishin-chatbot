# frozen_string_literal: true
require 'rails_helper'

# describe Websockets::Manager do
#   subject(:service) { described_class.new }
#
#   let(:platform) { 'slack' }
#
#   describe '.start_all' do
#     let!(:teams) { create_list(:team, 3) }
#
#     before do
#       allow(Websockets::Slack).to receive(:new_thread)
#       service.start_all
#     end
#
#     it 'creates a new thread for each team' do
#       teams.each do |team|
#         expect(Websockets::Slack).to have_received(:new_thread).with(team)
#       end
#     end
#   end
#
#   describe '.stop_all' do
#     let!(:teams) { create_list(:team, 3) }
#
#     before do
#       allow(Websockets::Slack).to receive(:new_thread)
#       service.start_all
#       allow(Thread).to receive(:kill)
#       service.stop_all
#     end
#
#     it 'kills each thread' do
#       expect(Thread).to have_received(:kill).exactly(teams.size).times
#     end
#   end
#
#   describe '.add' do
#     let(:team) { build(:team) }
#
#     before do
#       allow(Websockets::Slack).to receive(:new_thread)
#       service.add(team)
#     end
#
#     it 'creates a new thread' do
#       expect(Websockets::Slack).to have_received(:new_thread).with(team)
#     end
#   end
#
#   describe '.remove' do
#     let!(:team) { create(:team) }
#
#     before do
#       allow(Websockets::Slack).to receive(:new_thread)
#       service.add(team)
#
#       allow(Thread).to receive(:kill)
#       service.remove(team)
#     end
#
#     it 'kills the thread' do
#       expect(Thread).to have_received(:kill)
#     end
#   end
# end
