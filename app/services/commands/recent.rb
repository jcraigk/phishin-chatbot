# frozen_string_literal: true
class Commands::Recent
  include CommandsHelper

  DEFAULT_RESPONSE = 'You want a recent *what* now?'

  attr_reader :option

  def initialize(option:)
    @option = option
  end

  def call
    return latest_show_setlist if option.blank?
    track_details || DEFAULT_RESPONSE
  end

  private

  def latest_show_setlist
    ::Commands::Date.new(date: latest_show.date).call
  end

  def latest_show
    @latest_show ||=
      Phishin::Client.call(
        'shows',
        params: { sort_attr: :date, sort_dir: :desc, per_page: 1 }
      ).first
  end

  def latest_track
    track_by_song_slug || track_by_title_search
  end

  def track_details
    return if latest_track.nil?
    date = latest_track.show_date
    show = show_on_date(date)
    str = "The last performance of *#{latest_track.title}* was on "
    str += "*#{pretty_date(date)}* @ *#{show.venue_name}*\n"
    str + "https://phish.in/#{date}/#{latest_track.slug}"
  end

  def show_on_date(date)
    Phishin::Client.call("shows/#{date}")
  end

  def track_by_song_slug
    song_by_slug(option)&.tracks&.last
  end

  def song_by_slug(slug)
    @song_by_slug ||= Phishin::Client.call("songs/#{slug}")
  end

  def track_by_title_search
    return if song_by_title_search.nil?
    song_by_slug(song_by_title_search.slug)
  end

  def song_by_title_search
    @song_by_title_search ||= Phishin::Client.call("search/#{option}").songs.first
  end
end
