# frozen_string_literal: true
class SlackCallbackController < ActionController::API
  def event
    return success if command.blank?
    Slack::Emitter.call(channel, chat_response)
    success
  end

  private

  def success
    head 200
  end

  def channel
    params.dig('event', 'channel')
  end

  def command
    @command ||= Slack::Parser.call(params)
  end

  def chat_response
    ChatResponder.call(:slack, command)
  end
end
