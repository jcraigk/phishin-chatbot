# frozen_string_literal: true
require 'rails_helper'

describe Commands::Jamchart, :vcr do
  subject(:service) { described_class.new(option: option) }

  shared_examples 'expected response' do
    it 'returns expected response' do
      expect(service.call).to eq(expected_response)
    end
  end

  context 'with invalid song spec' do
    let(:option) { 'invalidoption' }
    let(:expected_response) do
      "Hmm, *\"#{option}\"* doesn't seem to match any songs"
    end

    include_examples 'expected response'
  end

  context 'with unpopulated song spec' do
    let(:option) { 'hurrah' }
    let(:expected_response) do
      "Sorry, there aren't any *Jamcharts* for *The Final Hurrah*"
    end

    include_examples 'expected response'
  end

  context 'with populated song spec' do
    let(:option) { 'hood' }
    let(:expected_response) do
      "Here's a *Jamchart* selection: *Harry Hood* performed on " \
      '*Jul 1, 1995* lasting *14m 37s* ▶ https://phish.in/1995-07-01/harry-hood'
    end

    before do
      allow_any_instance_of(Array).to receive(:sample).and_return(12_729) # rubocop: disable RSpec/AnyInstance
    end

    include_examples 'expected response'
  end
end
