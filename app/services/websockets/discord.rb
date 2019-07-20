# frozen_string_literal: true
class Websockets::Discord
  def self.new_thread
    bot = Discordrb::Bot.new(token: ENV['DISCORD_BOT_TOKEN'])

    bot.message do |event|
      Timestamper.register(:discord, event.channel.server.id)
      next unless (command = Parsers::Discord.call(event))
      response = CommandDispatch.call(:discord, command)
      event.respond(response)
    end

    Thread.new { bot.run }
  end
end
