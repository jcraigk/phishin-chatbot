# frozen_string_literal: true

# TODO: specs
class Commands::Random
  include CommandsHelper

  DEFAULT_RESPONSE = 'You want a random *what* now?'

  attr_reader :option

  def initialize(option:)
    @option = option
  end

  def call
    return random_show_setlist if option_dismissable?
    random_track_details || DEFAULT_RESPONSE
  end

  private

  def option_dismissable?
    option.blank? || option == 'show'
  end

  def random_show_setlist
    ::Commands::Date.new(date: random_show.date).call
  end

  def random_show
    @random_show ||= Phishin::Client.call('random-show')
  end

  def random_track_details
    song = song_match(option)
    return unless (tracks = song&.tracks).any?

    "Here's a random *#{song.title}*: " \
    "#{track_details_from_collection(tracks, rand(0..tracks.size - 1))}"
  end
end
