# frozen_string_literal: true
class Slack::Parser
  attr_reader :data

  CHATBOT_REGEX = /\A<@[A-Z0-9]+>/.freeze

  def initialize(data)
    @data = data
  end

  def self.call(data)
    new(data).call
  end

  def call
    return unless relevant_message?
    command
  end

  private

  # Extract "hi there" from "<@BOTUSERXYZ> hi there"
  def command
    @command ||= text.gsub(CHATBOT_REGEX, '').strip
  end

  def text
    @text ||= data.dig('event', 'text')
  end

  def relevant_message?
    directed_at_app? && command.present?
  end

  def directed_at_app?
    phishin_app_id? && (app_mention? || relevant_direct_message?)
  end

  def phishin_app_id?
    data['api_app_id'] == ENV['SLACK_APP_ID']
  end

  def app_mention?
    data.dig('event', 'type') == 'app_mention'
  end

  # To prevent double responses, ignore direct messages prefixed with chatbot mention
  # since such a message's `app_mention` event will trigger a separate response
  def relevant_direct_message?
    direct_message? && !message_from_bot? #&& !prefixed_with_bot_mention?
  end

  # def prefixed_with_bot_mention?
  #   !text.match?(CHATBOT_REGEX)
  # end

  def message_from_bot?
    data.dig('event', 'subtype') == 'bot_message'
  end

  def direct_message?
    data.dig('event', 'channel_type') == 'im'
  end
end
