# frozen_string_literal: true
require 'rails_helper'

describe Commands::Selector do
  subject(:service) { described_class.new(keyword: keyword, option: option) }

  let(:keyword) { 'last' }

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
        Here's the last show: *Jul 14, 2019* @ *Alpine Valley Music Theatre* with *39 likes* ▶ https://phish.in/2019-07-14
      TXT
    end

    include_examples 'expected response'
  end

  context 'with valid song' do
    let(:option) { 'hood' }
    let(:expected_response) do
      <<~TXT
        Here's the last *Harry Hood* performance: *Jul 13, 2019* @ *Alpine Valley Music Theatre* ▶ https://phish.in/2019-07-13/harry-hood
      TXT
    end

    include_examples 'expected response'
  end

  context 'with pluralized song' do
    let(:option) { 'hoods' }
    let(:expected_response) do
      <<~TXT
        Here are the last 5 *Harry Hood* performances:
        1. *Jul 13, 2019* @ *Alpine Valley Music Theatre* ▶ https://phish.in/2019-07-13/harry-hood
        2. *Jul 2, 2019* @ *Saratoga Performing Arts Center* ▶ https://phish.in/2019-07-02/harry-hood
        3. *Jun 22, 2019* @ *Merriweather Post Pavilion* ▶ https://phish.in/2019-06-22/harry-hood
        4. *Dec 31, 2018* @ *Madison Square Garden* ▶ https://phish.in/2018-12-31/harry-hood-2
        5. *Dec 31, 2018* @ *Madison Square Garden* ▶ https://phish.in/2018-12-31/harry-hood
      TXT
    end

    include_examples 'expected response'
  end

  context 'with count and song' do
    let(:option) { '3 mangos' }
    let(:expected_response) do
      <<~TXT
        Here are the last 3 *The Mango Song* performances:
        1. *Jun 30, 2019* @ *BB&T Pavilion* ▶ https://phish.in/2019-06-30/the-mango-song
        2. *Aug 5, 2018* @ *Verizon Wireless Amphitheatre at Encore Park* ▶ https://phish.in/2018-08-05/the-mango-song
        3. *Jul 21, 2017* @ *Madison Square Garden* ▶ https://phish.in/2017-07-21/the-mango-song
      TXT
    end

    include_examples 'expected response'
  end
end
