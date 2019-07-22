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
    if first_word == 'help'
      ::Commands::Help.new
    elsif first_word.in?(%w[recent last])
      ::Commands::Recent.new(option: command_opts_str)
    elsif parsable_date
      ::Commands::Date.new(date: date_str, option: last_word)
    else
      ::Commands::Unknown.new
    end
  end

  def date_str
    parsable_date.to_s
  end

  def parsable_date
    Date.parse(command)
  rescue ArgumentError
    false
  end

  def command_opts_str
    words.drop(1).join(' ')
  end

  def first_word
    words.first
  end

  def last_word
    words.last
  end

  def words
    @words ||= command.split(' ').map(&:downcase)
  end
end
