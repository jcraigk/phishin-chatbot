# frozen_string_literal: true
class Responders::Naive
  include ResponseHelpers

  PHRASES = [
    "Don't ask me cuz *I don't know*; I just fasten my seat belt wherever I go",
    "*I can't talk* my talk with you"
  ].freeze

  def call(platform)
    return random_phrase if platform == :slack
    slack_to_discord(random_phrase)
  end

  private

  def random_phrase
    @random_phrase ||= PHRASES.sample
  end
end
