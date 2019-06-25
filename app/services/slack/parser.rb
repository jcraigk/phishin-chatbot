# frozen_string_literal: true
class Slack::Parser
  attr_reader :data

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
    @command ||= data.dig('event', 'text').gsub(/\A<\@[A-Z0-9]{5,20}> /, '')
  end

  def relevant_message?
    phishin_app_id? && directed_at_bot? && command.present?
  end

  def directed_at_bot?
    app_mention? || direct_message?
  end

  def phishin_app_id?
    data['api_app_id'] == ENV['SLACK_APP_ID']
  end

  def app_mention?
    data.dig('event', 'type') == 'app_mention'
  end

  # TODO: to prevent double-post, don't include direct messages that include bot name
  # so "@phishin 1995-10-31" should be ignored since it gets picked up by app_mention event
  # instead, only listen for "1995-10-31"
  def direct_message?
    data.dig('event', 'channel_type') == 'im' &&
      data.dig('event', 'subtype') != 'bot_message'
  end
end
