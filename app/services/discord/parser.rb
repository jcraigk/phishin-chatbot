# frozen_string_literal: true
class Discord::Parser
  attr_reader :event

  CHATBOT_REGEX = /\A<@\d+>/.freeze

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
    event.message.content.gsub(CHATBOT_REGEX, '').strip
  end
end
