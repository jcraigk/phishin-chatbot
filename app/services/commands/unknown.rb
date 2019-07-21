# frozen_string_literal: true
class Commands::Unknown
  PHRASES = [
    "*I don't know* but I think I'll go and try dog mushing with an eskimo",
    "*I don't know* what changed my mind, 'til then I was the ramblin' kind",
    "Don't ask me cuz *I don't know*; I just fasten my seat belt wherever I go",
    "Don't want to be anything where *I don't know* when to stop",
    "If I could I would, but *I don't know* how",
    "Trapped in time and *I don't know* what to do"
  ].freeze

  def call
    PHRASES.sample
  end
end
