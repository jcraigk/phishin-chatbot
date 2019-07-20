# frozen_string_literal: true
require 'rails_helper'

describe Parsers::Slack do
  subject(:service) { described_class.new(data, app_bot_user_id) }

  let(:data) { OpenStruct.new(text: "<@#{bot_user_id}> #{message}") }
  let(:message) { 'hi there' }
  let(:app_bot_user_id) { 'BOTUSERXYZ' }

  shared_examples 'message parsing' do
    it 'extracts the message' do
      expect(service.call).to eq(extracted_message)
    end
  end

  context 'when bot_user_id matches ours' do
    let(:bot_user_id) { app_bot_user_id }
    let(:extracted_message) { message }

    include_examples 'message parsing'
  end

  context 'when bot_user_id does not match ours' do
    let(:bot_user_id) { 123 }
    let(:extracted_message) { nil }

    include_examples 'message parsing'
  end
end
