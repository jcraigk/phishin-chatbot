# frozen_string_literal: true
class Discord::Parser
  attr_reader :event

  def initialize(event)
    @event = event
  end

  def self.call(event)
    new(event).call
  end

  def call
    extract_message
  end

  private

  # Extract "hi there" from "<@592570302473169665> hi there"
  def extract_message
    event.message.content.gsub(/\A<@\d+> /, '')
  end
end
