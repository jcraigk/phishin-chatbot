# frozen_string_literal: true
require 'rails_helper'

describe Commands::Selector do
  subject(:service) { described_class.new(keyword: keyword, option: option) }

  let(:keyword) { 'shortest' }

  shared_examples 'expected response' do
    it 'returns expected response' do
      VCR.use_cassette "Commands_Selector/#{keyword}" do
        expect(service.call).to eq(expected_response)
      end
    end
  end

  context 'without an option' do
    let(:option) { nil }
    let(:expected_response) do
      <<~TXT
        Here's the shortest show: *Jun 27, 2000* @ *NBC Studios, New York* ▶ https://phish.in/2000-06-27
      TXT
    end

    include_examples 'expected response'
  end

  context 'with valid song' do
    let(:option) { 'hood' }
    let(:expected_response) do
      <<~TXT
        Here's the shortest *Harry Hood* performance: *Jun 22, 2000* @ *Starwood Ampitheater* lasting *2m 32s* ▶ https://phish.in/2000-06-22/harry-hood
      TXT
    end

    include_examples 'expected response'
  end

  context 'with pluralized song' do
    let(:option) { 'hoods' }
    let(:expected_response) do
      <<~TXT
        Here are the 5 shortest *Harry Hood* performances:
        1. *Jun 22, 2000* @ *Starwood Ampitheater* lasting *2m 32s* ▶ https://phish.in/2000-06-22/harry-hood
        2. *Dec 31, 2018* @ *Madison Square Garden* lasting *3m 24s* ▶ https://phish.in/2018-12-31/harry-hood-2
        3. *Jun 4, 2011* @ *Blossom Music Center* lasting *3m 53s* ▶ https://phish.in/2011-06-04/harry-hood-2
        4. *Jul 26, 1997* @ *South Park Meadows* lasting *4m 2s* ▶ https://phish.in/1997-07-26/harry-hood-2
        5. *Oct 30, 2016* @ *MGM Grand Garden Arena* lasting *5m 38s* ▶ https://phish.in/2016-10-30/harry-hood-2
      TXT
    end

    include_examples 'expected response'
  end

  context 'with count and song' do
    let(:option) { '3 mangos' }
    let(:expected_response) do
      <<~TXT
        Here are the 3 shortest *The Mango Song* performances:
        1. *May 26, 1989* @ *Valley Club Café* lasting *5m 5s* ▶ https://phish.in/1989-05-26/the-mango-song
        2. *Apr 16, 1991* @ *Rick's Café* lasting *6m 23s* ▶ https://phish.in/1991-04-16/the-mango-song
        3. *Apr 15, 1989* @ *Billings Lounge, University of Vermont* lasting *6m 34s* ▶ https://phish.in/1989-04-15/the-mango-song
      TXT
    end

    include_examples 'expected response'
  end
end
