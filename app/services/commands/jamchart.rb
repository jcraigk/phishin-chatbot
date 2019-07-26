# frozen_string_literal: true
class Commands::Jamchart < Commands::Base
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
    return unless candidate_ids.any?
    track = track_by_id(candidate_ids.sample)

    "Here's a *Jamchart* selection: " \
    "*#{track.title}* performed on *#{pretty_date(track.show_date)}* " \
    "lasting *#{readable_duration(track.duration, style: 'letters')}* " \
    "#{track_link(track)}"
  end

  def track_by_id(id)
    Phishin::Client.call("tracks/#{id}")
  end

  def tag
    @tag ||= Phishin::Client.call('tags/jamcharts')
  end

  def candidate_ids
    @candidate_ids ||= option.blank? ? tag.track_ids : tag.track_ids & song_track_ids
  end
end
