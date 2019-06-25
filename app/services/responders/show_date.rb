# frozen_string_literal: true
class Responders::ShowDate
  attr_reader :date, :options

  def initialize(date:, options:)
    @date = date
    @options = options
  end

  def call(platform)
    "#{platform} => #{data[:date]} @ #{data[:venue][:name]}"
  end

  private

  def data
    @data ||= PhishinClient.call("shows/#{date}")
  end
end
