# frozen_string_literal: true
class Responders::Naive
  include ResponseHelpers

  PHRASES = [
    "Don't ask me cuz *I don't know*; I just fasten my seat belt wherever I go",
    "*I can't talk* my talk with you"
  ].freeze

  def call(platform)
    formatted_phrase(platform)
  end

  private

  def formatted_phrase(platform)
    return random_phrase if platform == :slack
    slack_to_discord(random_phrase)
  end

  def random_phrase
    @random_phrase ||= PHRASES.sample
  end
end
