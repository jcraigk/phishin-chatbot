# frozen_string_literal: true
class Responders::Naive
  include ResponseHelpers

  PHRASES = [
    "Don't ask me cuz *I don't know*; I just fasten my seat belt wherever I go",
    "*I can't talk* my talk with you"
  ].freeze

  def call(platform)
    platform_formatted_text(platform)
  end

  private

  def platform_formatted_text(platform)
    return random_phrase if platform == :slack
    slack_to_discord(random_phrase)
  end

  def random_phrase
    @random_phrase ||= PHRASES.sample
  end
end
