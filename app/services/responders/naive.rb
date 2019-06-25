# frozen_string_literal: true
class Responders::Naive
  NAIVE_RESPONSES = [
    "Don't ask me cuz I don't know; I just fasten my seat belt wherever I go",
    "I can't talk my talk with you"
  ].freeze

  def discord
    respond_naively
  end

  def slack
    respond_naively
  end

  private

  def respond_naively
    NAIVE_RESPONSES.sample
  end
end
