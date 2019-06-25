# frozen_string_literal: true
class Responders::ShowDate
  include ResponseHelpers

  attr_reader :date, :options

  def initialize(date:, args:)
    @date = date
    @options = args.present? ? args.split(',') : []
  end

  def call(platform)
    return 'The banker said *"I ain\'t got that"*' unless data
    response = options.include?('detail') ? detailed_response : brief_response

    return response if platform == :slack
    slack_to_discord(response)
  end

  private

  def brief_response
    return @str if @str

    @str = "*#{pretty_date}*"
    @str += options.include?('tall') ? "\n" : ' @ '
    @str += "*#{data.venue_name}*\n"
    @str += "*This show is incomplete*\n" if data.incomplete
    @str += full_setlist

    @str
  end

  def detailed_response
    return @str if @str

    @str = "*#{pretty_date}*\n"
    @str += "*Venue:* #{data.venue_name} in #{location}\n"
    @str += "*This show is incomplete*\n" if data.incomplete
    @str += "*Duration:* #{show_duration}\n"
    @str += "*Tags:* #{stacked_tag_names}\n" if combined_tag_names.any?
    @str += "*Stream Audio:* #{web_link}\n\n"

    @str += full_setlist

    @str
  end

  def full_setlist
    str = ''
    sets.each do |set, tracks|
      if options.include?('tall')
        str += "\n*#{set_name(set)}*"
        str += "  (#{set_duration(tracks)})" if options.include?('detail')
        str += "\n"
        tracks.each_with_index do |track, idx|
          str += "#{idx + 1}. #{track.title}\n"
        end
      else
        setlist = tracks.map(&:title).join(', ')
        str += "*#{set_name(set)}:*  #{setlist}\n"
      end
    end
    str
  end

  def stacked_tag_names
    tag_counts.map do |name, count|
      str = name
      str += " (#{count})" if count > 1
      str
    end.join(', ')
  end

  def tag_counts
    Hash[*combined_tag_names.group_by { |v| v }.flat_map { |k, v| [k, v.size] }]
  end

  def web_link
    "#{ResponseHelpers::BASE_PHISHIN_URL}/#{data.date}"
  end

  def combined_tag_names
    (show_tag_names + track_tag_names).sort
  end

  def track_tag_names
    data.tracks.map(&:tags).reject(&:empty?).flatten.map(&:name).sort
  end

  def show_tag_names
    data.tags.map(&:name).sort
  end

  def show_duration
    duration_readable(data.duration, style: 'letters')
  end

  def set_duration(tracks)
    duration_readable(tracks.map(&:duration).inject(0, &:+), style: 'letters')
  end

  def location
    data.venue.location
  end

  def pretty_date
    Date.parse(data.date).strftime('%B %e, %Y')
  end

  def sets
    @sets ||= data.tracks.group_by(&:set)
  end

  def data
    @data ||= Phishin::Client.call("shows/#{date}")
  end
end
