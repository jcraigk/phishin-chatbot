# frozen_string_literal: true
class Websockets::Discord
  def self.new_thread(team)
    bot = Discordrb::Bot.new(token: team.token)

    bot.message do |event|
      Timestamper.register_event(team.id)
      next unless (command = Parsers::Discord.call(event))
      event.respond(ChatResponder.call(:discord, command))
    end

    Thread.new { bot.run }
  end
end
