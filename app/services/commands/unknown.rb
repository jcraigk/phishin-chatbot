# frozen_string_literal: true
class Commands::Unknown
  PHRASES = [
    "*I don't know* but I think I'll go and try dog mushing with an eskimo",
    "Don't ask me cuz *I don't know*; I just fasten my seat belt wherever I go",
    "If I could I would, but *I don't know* how",
    "Trapped in time and *I don't know* what to do"
  ].freeze

  def call
    PHRASES.sample
  end
end
