# frozen_string_literal: true
class Responders::ShowDate
  include ResponseHelpers

  attr_reader :date, :options

  def initialize(date:, options:)
    @date = date
    @options = options
  end

  def call(platform)
    return 'The banker said *"I ain\'t got that"*' unless data
    return build_response if platform == :slack
    slack_to_discord(build_response)
  end

  private

  def build_response
    return @str if @str

    @str = "#{header}\n"
    @str += "#{web_link}\n"
    @str += "*This show is incomplete*\n" if data[:incomplete]
    @str += "*Show Tags:* #{show_tag_names.join(', ')}\n" if show_tag_names.any?
    @str += sets.map do |set, tracks|
      setlist = tracks.map { |t| t[:title] }.join(', ')
      "*#{set_name(set)}:*  #{setlist}"
    end.join("\n")
    @str += "\n"

    @str
  end

  def header
    "*#{pretty_date}*   #{data[:venue_name]} in #{location}   *#{pretty_duration}*"
  end

  def web_link
    "#{ResponseHelpers::BASE_PHISHIN_URL}/#{data[:date]}"
  end

  def show_tag_names
    data[:tags].map { |t| t[:name] }.uniq.sort
  end

  def pretty_duration
    duration_readable(data[:duration], style: 'letters')
  end

  def location
    data[:venue][:location]
  end

  def pretty_date
    Date.parse(data[:date]).strftime('%B %e, %Y')
  end

  def sets
    @sets ||= data[:tracks].group_by { |t| t[:set] }
  end

  def data
    @data ||= Phishin::Client.call("shows/#{date}")
  end
end
