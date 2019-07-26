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

  def format_for_discord(text)
    text.gsub(/\*/, '**')
  end

  def name_of_set(set)
    SET_NAMES[set] || 'Unknown Set'
  end

  def readable_duration(milliseconds, style: 'colons')
    DurationFormatter.new(milliseconds, style).call
  end

  def pretty_date(date)
    Date.parse(date).strftime('%b %-d, %Y')
  end

  def show_on_date(date)
    return if date.blank?
    Phishin::Client.call("shows/#{date}")
  end

  def song_match(str)
    song_by_slug(str) || song_by_partial_title(str)
  end

  def song_by_slug(slug)
    return if slug.blank?
    Phishin::Client.call("songs/#{slug}")
  end

  def song_by_partial_title(term)
    song_by_slug(first_matching_song(term)&.slug)
  end

  def first_matching_song(term)
    return if term.blank?
    Phishin::Client.call("search/#{term}").songs.first
  end

  def track_tag_names(tracks)
    tracks.map(&:tags).reject(&:empty?).flatten.map(&:name).sort
  end

  def stacked_tag_names(tag_names)
    Hash[
      *tag_names.group_by { |v| v }.flat_map { |k, v| [k, v.size] }
    ].map do |name, count|
      str = name
      str += " (#{count})" if count > 1
      str
    end.join(', ')
  end

  def track_link(track)
    "\u25B6 #{BASE_PHISHIN_URL}/#{track.show_date}/#{track.slug}"
  end

  def show_link(show)
    "\u25B6 #{BASE_PHISHIN_URL}/#{show.date}"
  end

  def simple_pluralize(count, noun)
    return if count.zero?
    count == 1 ? noun : noun.pluralize
  end
end
