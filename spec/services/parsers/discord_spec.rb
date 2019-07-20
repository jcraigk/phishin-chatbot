# frozen_string_literal: true
require 'rails_helper'

describe Parsers::Discord do
  subject(:service) { described_class.new(data) }

  let(:data) do
    OpenStruct.new(
      message: OpenStruct.new(
        content: "<@#{client_id}> #{message}"
      )
    )
  end
  let(:message) { 'hi there' }

  shared_examples 'message parsing' do
    it 'extracts the message' do
      expect(service.call).to eq(extracted_message)
    end
  end

  context 'when client id matches ours' do
    let(:client_id) { ENV['DISCORD_CLIENT_ID'] }
    let(:extracted_message) { message }

    include_examples 'message parsing'
  end

  context 'when client id does not match ours' do
    let(:client_id) { 123 }
    let(:extracted_message) { nil }

    include_examples 'message parsing'
  end
end
