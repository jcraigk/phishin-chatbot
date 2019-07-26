# frozen_string_literal: true
require 'rails_helper'

describe Commands::Unknown do
  subject(:service) { described_class.new }

  let(:phrase) { 'I do not know' }

  before { stub_const('Commands::Unknown::PHRASES', [phrase]) }

  it 'returns a random selection from its set of phrases' do
    expect(service.call).to eq("#{phrase}; maybe I can `help` you party down?")
  end
end
