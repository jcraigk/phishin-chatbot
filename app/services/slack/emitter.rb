# frozen_string_literal: true

# https://api.slack.com/methods/chat.postMessage
class Slack::Emitter
  BASE_URL = 'https://slack.com/api/chat.postMessage'

  attr_reader :channel, :text

  def initialize(channel, text)
    @channel = channel
    @text = text
  end

  def self.call(channel, text)
    new(channel, text).call
  end

  def call
    Rails.logger.debug("SLACK: Emitting to #{channel} => #{text}")
    emit
  end

  private

  def emit
    HTTP.auth("Bearer #{ENV['SLACK_BOT_TOKEN']}").post(BASE_URL, json: { channel: channel, text: text })
  end
end
