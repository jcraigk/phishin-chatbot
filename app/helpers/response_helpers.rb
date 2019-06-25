# frozen_string_literal: true
module ResponseHelpers
  SET_NAMES = {
    'S' => 'Soundcheck',
    '1' => 'Set 1',
    '2' => 'Set 2',
    '3' => 'Set 3',
    '4' => 'Set 4',
    'E' => 'Encore',
    'E2' => 'Encore 2',
    'E3' => 'Encore 3'
  }.freeze

  BASE_PHISHIN_URL = 'https://phish.in'

  def slack_to_discord(text)
    text.gsub(/\*/, '**')
  end

  def set_name(set)
    SET_NAMES[set] || 'Unknown Set'
  end

  def duration_readable(milliseconds, style: 'colons')
    DurationFormatter.new(milliseconds, style).call
  end
end