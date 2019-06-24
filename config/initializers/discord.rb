require 'discordrb'

if ENV['IS_DISCORD_WEBSOCKET'].present?
  bot = Discordrb::Bot.new(token: ENV['DISCORD_BOT_TOKEN'])

  bot.message do |event|
    msg = event.message.content

    # Extract "hi there" from "<@592570302473169665> check"
    chat_command = msg.gsub(/\A<@\d+> /, '')
    show_data = Phishin::Request.call("shows/#{chat_command}")
    chatback = "#{show_data[:date]} @ #{show_data[:venue][:name]}"

    event.respond(chatback)
  end

  bot.run
end
