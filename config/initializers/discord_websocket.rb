Thread.new do
  begin
    bot = Discordrb::Bot.new(token: ENV['DISCORD_BOT_TOKEN'])
    bot.message do |event|
      next unless (chat_command = Discord::Parser.call(event))
      event.respond(ChatResponder.call(:discord, chat_command))
    end
    bot.run
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end
