# frozen_string_literal: true
class Commands::Date < Commands::Base
  DEFAULT_RESPONSE = 'The banker said *"I ain\'t got that"*'

  def call
    return DEFAULT_RESPONSE unless show
    return detailed_response if option == 'more'
    standard_response
  end

  private

  def standard_response
    str = "*#{pretty_date(show.date)}* @ *#{show.venue_name}*\n"
    str += "#{show_link(show)}\n"
    str += "*This show is incomplete*\n" if show.incomplete
    str + horizontal_setlist
  end

  def detailed_response # rubocop:disable Metrics/AbcSize
    str = "*#{pretty_date(show.date)}*\n"
    str += "*Venue:* #{show.venue_name} in #{location}\n"
    str += "*This show is incomplete*\n" if show.incomplete
    str += "*Duration:* #{show_duration}\n"
    str += "*Tags:* #{stacked_tag_names(combined_tag_names)}\n" if combined_tag_names.any?
    str += "#{show_link(show)}\n"
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
      "    %<set>-25s %<duration>20s\n",
      set: name_of_set(set),
      duration: duration_of_set(tracks)
    )
  end

  def longform_setlist(tracks)
    tracks.map.with_index do |track, idx|
      format(
        '%<position>2d. %<title>-40.40s %<duration>5s',
        position: idx + 1,
        title: track.title,
        duration: readable_duration(track.duration)
      )
    end.join("\n")
  end

  def combined_tag_names
    (show_tag_names + track_tag_names(show.tracks)).sort
  end

  def show_tag_names
    show.tags.map(&:name).sort
  end

  def show_duration
    readable_duration(show.duration, style: 'letters')
  end

  def duration_of_set(tracks)
    readable_duration(tracks.map(&:duration).inject(0, &:+), style: 'letters')
  end

  def location
    show.venue.location
  end

  def sets
    @sets ||= show.tracks.group_by(&:set)
  end

  def show
    return if keyword.blank?
    @show ||= Phishin::Client.call("shows/#{keyword}")
  end
end
