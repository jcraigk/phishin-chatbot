# frozen_string_literal: true

# TODO: specs
class Commands::Jamchart
  include CommandsHelper

  attr_reader :option

  def initialize(option:)
    @option = option
  end

  def call
    random_jamchart || default_response
  end

  private

  def requested_song
    @requested_song = song_match(option)
  end

  def song_track_ids
    return [] if requested_song.blank?
    requested_song.tracks.map(&:id)
  end

  def default_response
    return "Sorry, there aren't any *Jamcharts* for *#{requested_song.title}*" if requested_song
    "Hmm, *\"#{option}\"* doesn't seem to match any songs"
  end

  def random_jamchart
    tag = Phishin::Client.call('tags/jamcharts')
    candidate_ids = option.blank? ? tag.track_ids : tag.track_ids & song_track_ids
    return unless candidate_ids.any?

    track = Phishin::Client.call("tracks/#{candidate_ids.sample}")
    track_song = option.blank? ? song_match(track.song_ids.first) : requested_song
    song_tracks = track_song.tracks
    idx = song_tracks.index { |t| t.id == track.id }
    details = track_details_from_collection(song_tracks, idx, display_tags: false)

    "A random *Jamchart* selection of *#{track_song.title}* #{details}"
  end
end
