# frozen_string_literal: true
class Parsers::Discord
  attr_reader :data

  # Discord uses app OAuth Client ID as bot ID in all guilds
  CHATBOT_REGEX = /\A<@#{ENV['DISCORD_CLIENT_ID']}> /.freeze

  def initialize(data)
    @data = data
  end

  def self.call(data)
    new(data).call
  end

  def call
    return unless relevant_message?
    extract_message
  end

  private

  def relevant_message?
    text.match?(CHATBOT_REGEX)
  end

  def text
    @text ||= data.message.content
  end

  # Extract "hi there" from "<@592570302473169665> hi there"
  def extract_message
    text.gsub(CHATBOT_REGEX, '').strip
  end
end
