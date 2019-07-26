# frozen_string_literal: true
require 'rails_helper'

describe Commands::Date, :vcr do
  subject(:service) { described_class.new(keyword: date, option: option) }

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
    let(:expected_response) do
      "*Jul 6, 2019* @ *Fenway Park*\n" \
      "▶ https://phish.in/2019-07-06\n" \
      "*Set 1:* Carini, Possum, Set Your Soul Free, Thread, Wolfman's Brother, " \
      'Reba, Back on the Train, Mound, About to Run, Down with Disease, Simple, ' \
      "Backwards Down the Number Line, Death Don't Hurt Very Long, 46 Days, What's the Use?, " \
      "Mexican Cousin, Also Sprach Zarathustra, Split Open and Melt, Suzy Greenberg\n" \
      '*Encore:* Rise/Come Together, Wilson'
    end

    include_examples 'expected response'

    context 'with `more` option' do
      let(:option) { 'more' }
      let(:expected_response) do
        "*Jul 6, 2019*\n" \
        "*Venue:* Fenway Park in Boston, MA\n" \
        "*Duration:* 2h 38m\n" \
        "*Tags:* Alt Lyric, Banter, Sample\n" \
        "▶ https://phish.in/2019-07-06\n" \
        "```\n" \
        "    Set 1                                   2h 28m\n" \
        "    ----------------------------------------------\n" \
        " 1. Carini                                    7:09\n" \
        " 2. Possum                                    8:00\n" \
        " 3. Set Your Soul Free                       13:06\n" \
        " 4. Thread                                    8:30\n" \
        " 5. Wolfman's Brother                         9:15\n" \
        " 6. Reba                                     11:02\n" \
        " 7. Back on the Train                         7:52\n" \
        " 8. Mound                                     6:02\n" \
        " 9. About to Run                              6:53\n" \
        "10. Down with Disease                        14:12\n" \
        "11. Simple                                    8:01\n" \
        "12. Backwards Down the Number Line            6:54\n" \
        "13. Death Don't Hurt Very Long                3:15\n" \
        "14. 46 Days                                   5:48\n" \
        "15. What's the Use?                           5:51\n" \
        "16. Mexican Cousin                            2:22\n" \
        "17. Also Sprach Zarathustra                   6:41\n" \
        "18. Split Open and Melt                      10:52\n" \
        "19. Suzy Greenberg                            7:04\n" \
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
