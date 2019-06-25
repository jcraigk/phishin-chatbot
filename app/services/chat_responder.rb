# frozen_string_literal: true
class ChatResponder
  attr_reader :platform, :command

  def initialize(platform, command)
    @platform = platform
    @command = command
  end

  def self.call(platform, command)
    new(platform, command).call
  end

  def call
    responder.call(platform)
  end

  private

  def responder
    if parsable_date
      ::Responders::ShowDate.new(date: parsable_date, args: last_word)
    else
      ::Responders::Naive.new
    end
  end

  def parsable_date
    Date.parse(command)
  rescue ArgumentError
    false
  end

  def last_word
    command.split(' ').last
  end
end
