# frozen_string_literal: true
require 'rails_helper'

describe Commands::Date do
  subject(:service) { described_class.new(date: Date.parse(date), option: option) }

  let(:option) { nil }

  shared_examples 'expected response' do
    it 'returns expected response' do
      expect(service.call).to eq(expected_response)
    end
  end

  context 'with invalid date' do
    let(:date) { '1980-01-01' }
    let(:expected_response) { Commands::Date::DEFAULT_RESPONSE }

    include_examples 'expected response'
  end

  context 'with valid date' do
    let(:date) { '2019-07-06' }
    let(:data) do
      {
        date: date,
        duration: 9_535_713,
        incomplete: false,
        tags: [
          {
            name: 'SBD'
          }
        ],
        venue: {
          name: 'Fenway Park',
          location: 'Boston, MA'
        },
        venue_name: 'Fenway Park',
        tracks: [
          {
            title: 'Carini',
            duration: 429_531,
            set: '1',
            tags: [
              {
                name: 'Banter'
              }
            ]
          },
          {
            title: 'Possum',
            duration: 480_235,
            set: '1',
            tags: [
              {
                name: 'Tease'
              },
              {
                name: 'Tease'
              }
            ]
          },
          {
            title: 'Set Your Soul Free',
            duration: 786_704,
            set: '1',
            tags: []
          },
          {
            title: 'Rise/Come Together',
            duration: 303_856,
            set: 'E',
            tags: []
          },
          {
            title: 'Wilson',
            duration: 296_333,
            set: 'E',
            tags: []
          }
        ]
      }
    end
    let(:data_as_openstruct) { JSON.parse(data.to_json, object_class: OpenStruct) }
    let(:expected_response) do
      "*July  6, 2019* @ *Fenway Park*\n" \
      "https://phish.in/2019-07-06\n" \
      "*Set 1:* Carini, Possum, Set Your Soul Free\n" \
      '*Encore:* Rise/Come Together, Wilson'
    end

    before do
      allow(Phishin::Client).to(
        receive(:call).with("shows/#{date}").and_return(data_as_openstruct)
      )
    end

    include_examples 'expected response'

    context 'with `more` option' do
      let(:option) { 'more' }
      let(:expected_response) do
        "*July  6, 2019*\n" \
        "*Venue:* Fenway Park in Boston, MA\n" \
        "*Duration:* 2h 38m\n" \
        "*Tags:* Banter, SBD, Tease (2)\n" \
        "https://phish.in/2019-07-06\n" \
        "```\n" \
        "    Set 1                                  28m 16s\n" \
        "    ----------------------------------------------\n" \
        " 1. Carini                                    7:09\n" \
        " 2. Possum                                    8:00\n" \
        " 3. Set Your Soul Free                       13:06\n" \
        "\n" \
        "    Encore                                  10m 0s\n" \
        "    ----------------------------------------------\n" \
        " 1. Rise/Come Together                        5:03\n" \
        " 2. Wilson                                    4:56\n" \
        '```'
      end

      include_examples 'expected response'
    end
  end
end
