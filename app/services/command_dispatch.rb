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
    response = generate_response
    return response if platform == :slack
    format_for_discord(response)
  end

  private

  def generate_response
    klass, keyword, option = parse_command
    command_object = "::Commands::#{klass}".constantize.new(keyword: keyword, option: option)
    return command_object.call if random?(keyword) # Don't cache `random` requests
    Rails.cache.fetch("#{klass}/#{keyword}/#{option}", expires_in: Rails.configuration.cache_ttl) do
      command_object.call
    end
  end

  def parse_command
    return ['Help', nil, nil] if first_word == 'help'
    return ['Jamchart', nil, opts_str] if first_word == 'jamchart'
    return ['Selector', first_word, opts_str] if selector?
    return ['Date', date_str, last_word] if parsable_date
    ['Unknown', nil, nil]
  end

  def random?(keyword)
    keyword.in?(%w[random jamchart])
  end

  def date_str
    parsable_date.to_s
  end

  def selector?
    first_word.in?(Commands::Selector.keywords)
  end

  def parsable_date
    Date.parse(command)
  rescue ArgumentError
    false
  end

  def opts_str
    words.drop(1).join(' ')
  end

  def first_word
    words.first
  end

  def last_word
    words.last
  end

  def words
    @words ||= command.split(/\s+/).map(&:downcase)
  end
end
