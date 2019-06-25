if ENV['DISCORD_WEBSOCKET'].present?
  require 'discordrb'

  bot = Discordrb::Bot.new(token: ENV['DISCORD_BOT_TOKEN'])
  bot.message do |event|
    # Extract "hi there" from "<@592570302473169665> hi there"
    event.respond(ChatResponder.call(:discord, event.message.content.gsub(/\A<@\d+> /, '')))
  end

  bot.run
end
