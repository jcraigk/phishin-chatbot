# frozen_string_literal: true
class Commands::Date
  include CommandsHelper

  attr_reader :date, :option

  DEFAULT_RESPONSE = 'The banker said *"I ain\'t got that"*'

  def initialize(date:, option: nil)
    @date = date
    @option = option
  end

  def call
    return DEFAULT_RESPONSE unless data
    return detailed_response if option == 'more'
    standard_response
  end

  private

  def standard_response
    str = "*#{pretty_date(data.date)}* @ *#{data.venue_name}*\n"
    str += web_link + "\n"
    str += "*This show is incomplete*\n" if data.incomplete
    str + horizontal_setlist
  end

  def detailed_response # rubocop:disable Metrics/AbcSize
    str = "*#{pretty_date(data.date)}*\n"
    str += "*Venue:* #{data.venue_name} in #{location}\n"
    str += "*This show is incomplete*\n" if data.incomplete
    str += "*Duration:* #{show_duration}\n"
    str += "*Tags:* #{stacked_tag_names}\n" if combined_tag_names.any?
    str += web_link + "\n"
    str + vertical_setlist
  end

  def horizontal_setlist
    sets.map do |set, tracks|
      "*#{name_of_set(set)}:* #{tracks.map(&:title).join(', ')}"
    end.join("\n")
  end

  def vertical_setlist
    str = "```\n"
    str += sets.map do |set, tracks|
      set_str = set_title_with_duration(set, tracks)
      set_str += horizontal_rule
      set_str + longform_setlist(tracks)
    end.join("\n\n")
    str + "\n```"
  end

  def horizontal_rule
    (' ' * 4) + ('-' * 46) + "\n"
  end

  def set_title_with_duration(set, tracks)
    format(
      "    %-25<set>s %20<duration>s\n",
      set: name_of_set(set),
      duration: duration_of_set(tracks)
    )
  end

  def longform_setlist(tracks)
    tracks.map.with_index do |track, idx|
      format(
        '%2<position>d. %-40.40<title>s %5<duration>s',
        position: idx + 1,
        title: track.title,
        duration: duration_readable(track.duration)
      )
    end.join("\n")
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
    "#{CommandsHelper::BASE_PHISHIN_URL}/#{data.date}"
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

  def duration_of_set(tracks)
    duration_readable(tracks.map(&:duration).inject(0, &:+), style: 'letters')
  end

  def location
    data.venue.location
  end

  def sets
    @sets ||= data.tracks.group_by(&:set)
  end

  def data
    @data ||= Phishin::Client.call("shows/#{date}")
  end
end
