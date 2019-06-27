# frozen_string_literal: true
Slack.configure do |config|
  config.token = ENV['SLACK_BOT_TOKEN']
end

Thread.new do
  client = Slack::RealTime::Client.new

  client.on :hello do
    puts "Slack websocket connected to '#{client.team.name}'"
  end

  # TODO need to get channel info separately to find out if direct message??
  client.on :message do |data|
    next unless (chat_command = Slack::Parser.call(data))
    chat_response = ChatResponder.call(:slack, command)
    client.message(channel: data.channel, text: chat_response)
  end

  client.on :close do |_data|
    print "Slack websocket for '#{client.team.name}' disconnecting..."
  end

  client.on :closed do |_data|
    puts 'done'
  end

  client.start!
end
