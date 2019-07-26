# frozen_string_literal: true
require 'rails_helper'

describe Commands::Selector, :vcr do
  subject(:service) { described_class.new(keyword: keyword, option: option) }

  let(:keyword) { 'top' }

  context 'with invalid option' do
    let(:option) { 'invalid-option' }
    let(:expected_response) do
      "I heard the `#{keyword}` keyword, but I don't understand *\"invalid-option\"*"
    end

    it 'returns expected response' do
      expect(service.call).to eq(expected_response)
    end
  end
end
