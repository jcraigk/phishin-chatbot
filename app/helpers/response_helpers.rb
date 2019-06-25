# frozen_string_literal: true
module ResponseHelpers
  def slack_to_discord(text)
    text.gsub(/\*/, '**')
  end
end
