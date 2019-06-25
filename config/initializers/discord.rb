if ENV['DISCORD_WEBSOCKET'].present?
  require 'discordrb'

  bot = Discordrb::Bot.new(token: ENV['DISCORD_BOT_TOKEN'])
  bot.message do |event|
    chat_command = Discord::EventParser.call(event)
    event.respond(ChatResponder.call(:discord, chat_command)) if chat_message
  end

  bot.run
end
