# frozen_string_literal: true

# https://discordapp.com/developers/docs/resources/channel#create-message
class Discord::Emitter
  BASE_URL = 'https://discordapp.com/api/v6'

  attr_reader :channel, :text

  def initialize(channel, text)
    @channel = channel
    @text = text
  end

  def call
    Rails.logger.debug("SLACK: Emitting to #{channel} => #{text}")
    emit
  end

  def self.call(channel, text)
    new(channel, text).call
  end

  private

  def url
    "#{BASE_URL}/channels/#{channel}/messages"
  end

  def emit
    HTTP.auth("Bot #{ENV['DISCORD_BOT_TOKEN']}").post(url, json: { content: text })
  end
end
