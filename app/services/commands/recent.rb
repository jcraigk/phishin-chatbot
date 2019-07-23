# frozen_string_literal: true

# TODO: spec
class Commands::Recent
  include CommandsHelper

  DEFAULT_RESPONSE = 'You want a recent *what* now?'

  attr_reader :option

  def initialize(option:)
    @option = option
  end

  def call
    return last_show_setlist if option_dismissable?
    last_track_details || DEFAULT_RESPONSE
  end

  private

  def option_dismissable?
    option.blank? || option == 'show'
  end

  def last_show_setlist
    ::Commands::Date.new(date: last_show.date).call
  end

  def last_show
    @last_show ||=
      Phishin::Client.call(
        'shows',
        params: { sort_attr: :date, sort_dir: :desc, per_page: 1 }
      ).first
  end

  def last_track_details
    song = song_match(option)
    return unless (tracks = song&.tracks).any?

    "The most recent *#{song.title}* took place on " \
    "#{track_details_from_collection(tracks, tracks.size - 1)}"
  end
end
