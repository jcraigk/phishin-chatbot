# frozen_string_literal: true
class CommandDispatch
  include CommandsHelper

  attr_reader :platform, :command

  def initialize(platform, command)
    @platform = platform.to_sym
    @command = command
  end

  def self.call(platform, command)
    new(platform, command).call
  end

  def call
    return response if platform == :slack
    slack_to_discord(response)
  end

  private

  def response
    @response ||= command_obj.call
  end

  def command_obj
    if command.downcase == 'help'
      ::Commands::Help.new
    elsif parsable_date
      ::Commands::Date.new(date: parsable_date, option: last_word)
    else
      ::Commands::Unknown.new
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
