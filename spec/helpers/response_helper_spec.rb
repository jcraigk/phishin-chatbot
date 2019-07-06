# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ResponseHelper do
  subject { helper }

  describe 'constants' do
    it 'defines BASE_PHISHIN_URL' do
      expect(described_class::BASE_PHISHIN_URL).to be_a(String)
    end

    it 'defines SET_NAMES' do
      expect(described_class::SET_NAMES).to be_a(Hash)
    end
  end

  describe '#slack_to_discord' do
    let(:discord_formatted) { 'Here is some **bold text**' }
    let(:slack_formatted) { 'Here is some *bold text*' }

    it 'returns Discord-formatted text' do
      expect(helper.slack_to_discord(slack_formatted)).to eq(discord_formatted)
    end
  end

  shared_examples 'set name from abbreviation' do
    it 'returns expected set name' do
      expect(helper.name_of_set(abbreviation)).to eq(full_name)
    end
  end

  describe '#name of set' do
    context 'when abbreviation is "S"' do
      let(:abbreviation) { 'S' }
      let(:full_name) { 'Soundcheck' }

      include_examples 'set name from abbreviation'
    end

    context 'when abbreviation is "1"' do
      let(:abbreviation) { '1' }
      let(:full_name) { 'Set 1' }

      include_examples 'set name from abbreviation'
    end

    context 'when abbreviation is ""' do
      let(:abbreviation) { '2' }
      let(:full_name) { 'Set 2' }

      include_examples 'set name from abbreviation'
    end

    context 'when abbreviation is "3"' do
      let(:abbreviation) { '3' }
      let(:full_name) { 'Set 3' }

      include_examples 'set name from abbreviation'
    end

    context 'when abbreviation is "4"' do
      let(:abbreviation) { '4' }
      let(:full_name) { 'Set 4' }

      include_examples 'set name from abbreviation'
    end

    context 'when abbreviation is "E"' do
      let(:abbreviation) { 'E' }
      let(:full_name) { 'Encore' }

      include_examples 'set name from abbreviation'
    end

    context 'when abbreviation is "E2"' do
      let(:abbreviation) { 'E2' }
      let(:full_name) { 'Encore 2' }

      include_examples 'set name from abbreviation'
    end

    context 'when abbreviation is "E3"' do
      let(:abbreviation) { 'E3' }
      let(:full_name) { 'Encore 3' }

      include_examples 'set name from abbreviation'
    end
  end

  describe '#duration_readable' do
    let(:milliseconds) { 10 }
    let(:mock_formatter) { instance_spy(DurationFormatter) }
    let(:style) { 'letters' }

    before do
      allow(DurationFormatter).to receive(:new).with(milliseconds, style).and_return(mock_formatter)
      allow(mock_formatter).to receive(:call)
      helper.duration_readable(milliseconds, style: style)
    end

    it 'calls DurationFormatter' do
      expect(mock_formatter).to have_received(:call)
    end
  end
end
