# frozen_string_literal: true
require 'rails_helper'

describe Commands::Selector, :vcr do
  subject(:service) { described_class.new(keyword: keyword, option: option) }

  let(:keyword) { 'random' }

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
        Here's a random show: *Dec 31, 1998* @ *Madison Square Garden* with *27 likes* ▶ https://phish.in/1998-12-31
      TXT
    end

    include_examples 'expected response'
  end

  # Pending due to difficulty in testing randomness
  # context 'with valid song' do
  #   let(:option) { 'hood' }
  #   let(:expected_response) do
  #      "Here's a random *Harry Hood* performance: *Nov 22, 1994* @ *Jesse" \
  #      " Auditorium, University of Missouri* ▶ https://phish.in/1994-11-22/harry-hood"
  #   end
  #
  #   include_examples 'expected response'
  # end

  # Pending due to difficulty in testing randomness
  # context 'with pluralized song' do
  #   let(:option) { 'hoods' }
  #   let(:expected_response) do
  #     <<~TXT
  #       Here are 5 random *Harry Hood* performances:
  #       1. *Jun 12, 2009* @ *Bonnaroo Music & Arts Festival* ▶ https://phish.in/2009-06-12/harry-hood
  #       2. *Oct 30, 2016* @ *MGM Grand Garden Arena* ▶ https://phish.in/2016-10-30/harry-hood
  #       3. *May 15, 1990* @ *Hamilton College* ▶ https://phish.in/1990-05-15/harry-hood
  #       4. *Jul 5, 1998* @ *Lucerna Theatre* ▶ https://phish.in/1998-07-05/harry-hood
  #       5. *Mar 24, 1992* @ *Flood Zone* ▶ https://phish.in/1992-03-24/harry-hood
  #     TXT
  #   end
  #
  #   include_examples 'expected response'
  # end

  # Pending due to difficulty in testing randomness
  # context 'with count and song' do
  #   let(:option) { '3 mangos' }
  #   let(:expected_response) do
  #     <<~TXT
  #       Here are 3 random *The Mango Song* performances:
  #       1. *Dec 1, 1995* @ *HersheyPark Arena* ▶ https://phish.in/1995-12-01/the-mango-song
  #       2. *Jul 24, 1993* @ *Great Woods* ▶ https://phish.in/1993-07-24/the-mango-song
  #       3. *Aug 20, 1993* @ *Red Rocks Amphitheatre* ▶ https://phish.in/1993-08-20/the-mango-song
  #     TXT
  #   end
  #
  #   include_examples 'expected response'
  # end
end
