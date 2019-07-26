# frozen_string_literal: true
require 'rails_helper'

describe Commands::Selector do
  subject(:service) { described_class.new(keyword: keyword, option: option) }

  let(:keyword) { 'longest' }

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
        Here's the longest show: *Dec 31, 1999* @ *Big Cypress Seminole Indian Reservation* with *245 likes* ▶ https://phish.in/1999-12-31
      TXT
    end

    include_examples 'expected response'
  end

  context 'with valid song' do
    let(:option) { 'hood' }
    let(:expected_response) do
      <<~TXT
        Here's the longest *Harry Hood* performance: *Jul 25, 2003* @ *Verizon Wireless Amphitheatre - Charlotte* lasting *29m 35s* ▶ https://phish.in/2003-07-25/harry-hood
      TXT
    end

    include_examples 'expected response'
  end

  context 'with pluralized song' do
    let(:option) { 'hoods' }
    let(:expected_response) do
      <<~TXT
        Here are the 5 longest *Harry Hood* performances:
        1. *Jul 25, 2003* @ *Verizon Wireless Amphitheatre - Charlotte* lasting *29m 35s* ▶ https://phish.in/2003-07-25/harry-hood
        2. *Jul 31, 2003* @ *Tweeter Center at the Waterfront* lasting *26m 25s* ▶ https://phish.in/2003-07-31/harry-hood
        3. *Aug 14, 1997* @ *Darien Lake Performing Arts Center* lasting *24m 33s* ▶ https://phish.in/1997-08-14/harry-hood
        4. *Oct 3, 1999* @ *Allstate Arena* lasting *22m 47s* ▶ https://phish.in/1999-10-03/harry-hood
        5. *Aug 14, 2004* @ *Newport State Airport* lasting *22m 35s* ▶ https://phish.in/2004-08-14/harry-hood
      TXT
    end

    include_examples 'expected response'
  end

  context 'with count and song' do
    let(:option) { '3 mangos' }
    let(:expected_response) do
      <<~TXT
        Here are the 3 longest *The Mango Song* performances:
        1. *Jul 24, 1999* @ *Alpine Valley Music Theatre* lasting *17m 22s* ▶ https://phish.in/1999-07-24/the-mango-song-jam-the-happy-whip-and-dung-song
        2. *Jun 30, 2000* @ *The Meadows* lasting *12m 12s* ▶ https://phish.in/2000-06-30/the-mango-song
        3. *Jul 15, 2000* @ *Polaris Amphitheater* lasting *10m 37s* ▶ https://phish.in/2000-07-15/the-mango-song
      TXT
    end

    include_examples 'expected response'
  end
end
