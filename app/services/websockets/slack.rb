# frozen_string_literal: true
class Websockets::Slack
  def self.new_thread(team)
    client = Slack::RealTime::Client.new(token: team.token)

    # TODO: handle team deactivation (and inactivity?)
    client.on :message do |event|
      next unless (command = Parsers::Slack.call(event, team.bot_user_id))
      chat_response = ChatResponder.call(:slack, command)
      client.message(channel: event.channel, text: chat_response)
    end

    Thread.new { client.start! }
  end
end
