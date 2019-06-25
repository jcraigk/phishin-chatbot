# frozen_string_literal: true
class Api::V1::SlackController < Api::ApiController
  def event
    return success unless slack_app_mention?
    Slack::Emitter.call(event_channel, response_message)
    success
  end

  private

  def success
    head 200
  end

  def slack_app_mention?
    phishin_app? && relevant_event? && chat_command.present?
  end

  def event_channel
    params.dig('event', 'channel')
  end

  # Extract "hi there" from "<@BOTUSERXYZ> hi there"
  def chat_command
    @chat_command ||= params.dig('event', 'text').gsub(/\A<\@[A-Z0-9]{5,20}> /, '')
  end

  def response_message
    ChatCommandRouter.call(:slack, chat_command)
  end

  def relevant_event?
    app_mention? || direct_message?
  end

  def phishin_app?
    params['api_app_id'] == ENV['SLACK_APP_ID']
  end

  def app_mention?
    params.dig('event', 'type') == 'app_mention'
  end

  # TODO: to prevent double-post, don't include direct messages that include bot name
  # so "@phishin 1995-10-31" should be ignored since it gets picked up by app_mention event
  # instead, only listen for "1995-10-31"
  def direct_message?
    params.dig('event', 'channel_type') == 'im' &&
      params.dig('event', 'subtype') != 'bot_message'
  end
end
