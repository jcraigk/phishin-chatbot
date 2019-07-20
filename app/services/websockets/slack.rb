# frozen_string_literal: true
class Websockets::Slack
  def self.new_thread(team) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    client = Slack::RealTime::Client.new(token: team.token)

    client.on :message do |event|
      team.register_event
      next unless (command = Parsers::Slack.call(event, team.bot_user_id))
      response = CommandDispatch.call(:slack, command)
      client.message(channel: event.channel, text: response)
    end

    client.on :tokens_revoked do |_event|
      Rails.logger.info("Tokens revoked for #{team.name} on #{team.platform}")
      team.disable
    end

    client.on :app_uninstalled do |_event|
      Rails.logger.info("App uninstalled for #{team.name} on #{team.platform}")
      team.disable
    end

    Thread.new { client.start! }
  end
end
