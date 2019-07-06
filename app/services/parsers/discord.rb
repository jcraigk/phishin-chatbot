# frozen_string_literal: true
class Parsers::Discord
  attr_reader :data

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

  # Discord uses app OAuth Client ID as bot ID in all guilds
  def chatbox_regex
    /\A<@#{ENV['DISCORD_CLIENT_ID']}> /
  end

  def relevant_message?
    text.match?(chatbox_regex)
  end

  def text
    @text ||= data.message.content
  end

  # Extract "hi there" from "<@592570302473169665> hi there"
  def extract_message
    text.gsub(chatbox_regex, '').strip
  end
end
