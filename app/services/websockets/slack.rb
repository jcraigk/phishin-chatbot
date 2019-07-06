# frozen_string_literal: true
class Websockets::Slack
  def self.new_thread(team)
    client = Slack::RealTime::Client.new(token: team.token)

    client.on :message do |event|
      team.register_event
      next unless (command = Parsers::Slack.call(event, team.bot_user_id))
      response = Commands::Dispatch.call(:slack, command)
      client.message(channel: event.channel, text: response)
    end

    client.on :tokens_revoked do |event|
      puts "Tokens revoked for #{team.name} on #{team.platform}"
      SocketManager.remove(team)
    end

    client.on :app_uninstalled do |event|
      puts "App uninstalled for #{team.name} on #{team.platform}"
      SocketManager.remove(team)
    end

    Thread.new { client.start! }
  end
end
