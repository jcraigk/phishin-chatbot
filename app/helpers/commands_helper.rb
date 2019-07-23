# frozen_string_literal: true
module CommandsHelper
  SET_NAMES = {
    'S' => 'Soundcheck',
    '1' => 'Set 1',
    '2' => 'Set 2',
    '3' => 'Set 3',
    '4' => 'Set 4',
    'E' => 'Encore',
    'E2' => 'Encore 2',
    'E3' => 'Encore 3'
  }.freeze

  BASE_PHISHIN_URL = 'https://phish.in'

  def slack_to_discord(text)
    text.gsub(/\*/, '**')
  end

  def name_of_set(set)
    SET_NAMES[set] || 'Unknown Set'
  end

  def readable_duration(milliseconds, style: 'colons')
    DurationFormatter.new(milliseconds, style).call
  end

  def pretty_date(date)
    Date.parse(date).strftime('%B %e, %Y')
  end

  def show_on_date(date)
    Phishin::Client.call("shows/#{date}")
  end

  def song_match(str)
    song_by_slug(str) || song_by_partial_title(str)
  end

  def song_by_slug(slug)
    Phishin::Client.call("songs/#{slug}")
  end

  def song_by_partial_title(term)
    song_by_slug(first_matching_song(term).slug)
  end

  def first_matching_song(term)
    Phishin::Client.call("search/#{term}").songs.first
  end

  # TODO: add tags
  def track_details_from_collection(tracks, idx)
    track = tracks[idx]
    date = track.show_date
    show = show_on_date(date)
    str = "*#{pretty_date(date)}* @ *#{show.venue_name}* clocking in at "
    str += "*#{readable_duration(track.duration)}*.  "
    str += "It's the *#{(idx + 1).ordinalize}* of *#{tracks.size}* total performances.\n"
    str + "https://phish.in/#{date}/#{track.slug}"
  end
end
