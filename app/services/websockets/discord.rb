# frozen_string_literal: true
class Websockets::Discord
  def self.new_thread
    bot = Discordrb::Bot.new(token: ENV['DISCORD_BOT_TOKEN'])

    bot.message do |event|
      # team.register_event # TODO: need to figure out which team is sending the data
      next unless (command = Parsers::Discord.call(event))
      response = Commands::Dispatch.call(:discord, command)
      event.respond(response)
    end

    Thread.new { bot.run }
  end
end
