if ENV['DISCORD_WEBSOCKET'].present?
  require 'discordrb'

  bot = Discordrb::Bot.new(token: ENV['DISCORD_BOT_TOKEN'])
  bot.message do |event|
    chat_command = Discord::Parser.call(event)
    event.respond(ChatResponder.call(:discord, chat_command)) if chat_command
  end

  bot.run
end
