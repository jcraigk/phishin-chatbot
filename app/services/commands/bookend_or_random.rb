# frozen_string_literal: true

# TODO: specs
class Commands::BookendOrRandom
  include CommandsHelper

  attr_reader :adjective, :option

  INTRO_TXT = {
    random: 'A randomly selected',
    first: 'The first',
    last: 'The last',
    shortest: 'The shortest',
    longest: 'The longest'
  }.freeze

  SHOW_SORT = {
    first: %i[date asc],
    last: %i[date desc],
    shortest: %i[duration asc],
    longest: %i[duration desc]
  }.freeze

  TRACK_SORT = {
    random: %w[show_date 0],
    first: %w[show_date 0],
    last: %w[show_date -1],
    shortest: %w[duration 0],
    longest: %w[duration -1]
  }.freeze

  def initialize(adjective:, option:)
    @adjective = adjective.to_sym
    @option = option
  end

  def call
    return show_setlist if option_dismissable?
    track_details || default_response
  end

  private

  def random?
    adjective == :random
  end

  def default_response
    "Hmm, *\"#{option}\"* doesn't seem to match any songs"
  end

  def option_dismissable?
    option.blank? || option == 'show'
  end

  def show_setlist
    ::Commands::Date.new(date: show.date).call
  end

  def show
    return Phishin::Client.call('random-show') if random?
    sort_attr, sort_dir = SHOW_SORT[adjective]
    Phishin::Client.call(
      'shows',
      params: { sort_attr: sort_attr, sort_dir: sort_dir, per_page: 1 }
    ).first
  end

  def track_details # rubocop:disable Metrics/AbcSize
    song = song_match(option)
    return if (tracks = song&.tracks).blank?

    sort_attr, idx = TRACK_SORT[adjective]
    idx = rand(0..tracks.size - 1) if random?
    tracks.sort_by! { |track| track.public_send(sort_attr) }
    details = track_details_from_collection(tracks, idx.to_i)

    "#{INTRO_TXT[adjective]} *#{song.title}* #{details}"
  end
end
