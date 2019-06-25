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
    if command =~ /\A(\d{4}\-\d{1,2}\-\d{1,2})( .+)?\z/ # 1995-10-31
      ::Responders::ShowDate.new(date: Regexp.last_match[1], args: Regexp.last_match[2]&.strip)
    else
      ::Responders::Naive.new
    end
  end
end
