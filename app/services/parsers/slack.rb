# frozen_string_literal: true
class Parsers::Slack
  attr_reader :data, :bot_user_id

  def initialize(data, bot_user_id)
    @data = data
    @bot_user_id = bot_user_id
  end

  def self.call(data, bot_user_id)
    new(data, bot_user_id).call
  end

  def call
    return unless relevant_message?
    command
  end

  private

  def chatbot_regex
    /\A@#{bot_user_id} /
  end

  def relevant_message?
    prefixed_with_bot_mention? && command.present?
  end

  def prefixed_with_bot_mention?
    text.match?(chatbot_regex)
  end

  # "<@BOTUSERXYZ>" => "@BOTUSERXYZ"
  def text
    Slack::Messages::Formatting.unescape(data.text)
  end

  # Extract "hi there" from "<@BOTUSERXYZ> hi there"
  def command
    @command ||= text.gsub(chatbot_regex, '').strip
  end
end
