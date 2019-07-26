# frozen_string_literal: true
require 'rails_helper'

describe Commands::Selector do
  subject(:service) { described_class.new(keyword: keyword, option: option) }

  let(:keyword) { 'first' }

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
        Here's the first show: *Dec 2, 1983* @ *Harris-Millis Cafeteria, University of Vermont* with *17 likes* ▶ https://phish.in/1983-12-02
      TXT
    end

    include_examples 'expected response'
  end

  context 'with valid song' do
    let(:option) { 'hood' }
    let(:expected_response) do
      <<~TXT
        Here's the first *Harry Hood* performance: *Oct 30, 1985* @ *Hunt's* ▶ https://phish.in/1985-10-30/harry-hood
      TXT
    end

    include_examples 'expected response'
  end

  context 'with pluralized song' do
    let(:option) { 'hoods' }
    let(:expected_response) do
      <<~TXT
        Here are the first 5 *Harry Hood* performances:
        1. *Oct 30, 1985* @ *Hunt's* ▶ https://phish.in/1985-10-30/harry-hood
        2. *Apr 1, 1986* @ *Hunt's* ▶ https://phish.in/1986-04-01/harry-hood
        3. *Oct 15, 1986* @ *Hunt's* ▶ https://phish.in/1986-10-15/harry-hood
        4. *Oct 31, 1986* @ *Sculpture Room, Goddard College* ▶ https://phish.in/1986-10-31/harry-hood
        5. *Feb 13, 1987* @ *Johnson State College* ▶ https://phish.in/1987-02-13/harry-hood
      TXT
    end

    include_examples 'expected response'
  end

  context 'with count and song' do
    let(:option) { '3 mangos' }
    let(:expected_response) do
      <<~TXT
        Here are the first 3 *The Mango Song* performances:
        1. *Mar 30, 1989* @ *The Front* ▶ https://phish.in/1989-03-30/the-mango-song
        2. *Apr 15, 1989* @ *Billings Lounge, University of Vermont* ▶ https://phish.in/1989-04-15/the-mango-song
        3. *May 26, 1989* @ *Valley Club Café* ▶ https://phish.in/1989-05-26/the-mango-song
      TXT
    end

    include_examples 'expected response'
  end
end
