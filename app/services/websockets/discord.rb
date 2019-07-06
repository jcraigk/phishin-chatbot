# frozen_string_literal: true
class Websockets::Discord
  def self.new_thread(team)
    bot = Discordrb::Bot.new(token: team.token)

    # TODO: handle team deactivation (and inactivity?)
    bot.message do |event|
      next unless (command = Parsers::Discord.call(event))
      event.respond(ChatResponder.call(:discord, command))
    end

    Thread.new { bot.run }
  end
end
