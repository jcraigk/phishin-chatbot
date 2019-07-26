# frozen_string_literal: true
require 'rails_helper'

describe Commands::Selector do
  subject(:service) { described_class.new(keyword: keyword, option: option) }

  let(:keyword) { 'top' }

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
        Here's the most liked show: *Dec 31, 1999* @ *Big Cypress Seminole Indian Reservation* with *245 likes* ▶ https://phish.in/1999-12-31
      TXT
    end

    include_examples 'expected response'
  end

  context 'with valid song' do
    let(:option) { 'hood' }
    let(:expected_response) do
      <<~TXT
        Here's the most liked *Harry Hood* performance: *Dec 31, 1993* @ *The Centrum* with *142 likes* ▶ https://phish.in/1993-12-31/harry-hood
      TXT
    end

    include_examples 'expected response'
  end

  context 'with pluralized song' do
    let(:option) { 'hoods' }
    let(:expected_response) do
      <<~TXT
        Here are the 5 most liked *Harry Hood* performances:
        1. *Dec 31, 1993* @ *The Centrum* with *142 likes* ▶ https://phish.in/1993-12-31/harry-hood
        2. *Aug 17, 1997* @ *Loring Commerce Center at Loring Air Force Base* with *51 likes* ▶ https://phish.in/1997-08-17/harry-hood
        3. *Dec 11, 1999* @ *First Union Spectrum* with *28 likes* ▶ https://phish.in/1999-12-11/harry-hood
        4. *Nov 22, 1997* @ *Hampton Coliseum* with *25 likes* ▶ https://phish.in/1997-11-22/harry-hood
        5. *Jul 1, 2014* @ *Xfinity Center* with *24 likes* ▶ https://phish.in/2014-07-01/harry-hood
      TXT
    end

    include_examples 'expected response'
  end

  context 'with count and song' do
    let(:option) { '3 mangos' }
    let(:expected_response) do
      <<~TXT
        Here are the 3 most liked *The Mango Song* performances:
        1. *Sep 17, 2000* @ *Merriweather Post Pavilion* with *14 likes* ▶ https://phish.in/2000-09-17/the-mango-song
        2. *Jun 30, 2000* @ *The Meadows* with *14 likes* ▶ https://phish.in/2000-06-30/the-mango-song
        3. *Jul 24, 1999* @ *Alpine Valley Music Theatre* with *13 likes* ▶ https://phish.in/1999-07-24/the-mango-song-jam-the-happy-whip-and-dung-song
      TXT
    end

    include_examples 'expected response'
  end

  context 'with singular keyword' do
    let(:option) { 'track' }
    let(:expected_response) do
      <<~TXT
        Here's the most liked track: *Bathtub Gin* performed on *Aug 17, 1997* with *218 likes* ▶ https://phish.in/1997-08-17/bathtub-gin
      TXT
    end

    include_examples 'expected response'
  end

  context 'with count and entity keyword' do
    let(:option) { '2 shows' }
    let(:expected_response) do
      <<~TXT
        Here are the 2 most liked shows:
        1. *Dec 31, 1999* @ *Big Cypress Seminole Indian Reservation* with *245 likes* ▶ https://phish.in/1999-12-31
        2. *Aug 17, 1997* @ *Loring Commerce Center at Loring Air Force Base* with *170 likes* ▶ https://phish.in/1997-08-17
      TXT
    end

    include_examples 'expected response'
  end
end
