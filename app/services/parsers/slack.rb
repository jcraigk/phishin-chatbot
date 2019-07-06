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

  def text
    Slack::Messages::Formatting.unescape(data.text)
  end

  # Extract "hi there" from "<@BOTUSERXYZ> hi there"
  def command
    @command ||= text.gsub(chatbot_regex, '').strip
  end


  # def directed_at_app?
  #   phishin_app_id? && (app_mention? || relevant_direct_message?)
  # end

  # def phishin_app_id?
  #   data['api_app_id'] == ENV['SLACK_APP_ID']
  # end

  # def app_mention?
  #   data.type == 'app_mention'
  # end

  # To prevent double responses, ignore direct messages prefixed with chatbot mention
  # since such a message's `app_mention` event will trigger a separate response
  # def relevant_direct_message?
  #   direct_message? && !message_from_bot? #&& !prefixed_with_bot_mention?
  # end
  #
  # def message_from_bot?
  #   data.subtype == 'bot_message'
  # end
  #
  # def direct_message?
  #   data.dig('event', 'channel_type') == 'im'
  # end
end
