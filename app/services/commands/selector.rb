# frozen_string_literal: true
class Commands::Selector < Commands::Base
  MAX_COUNT = 20
  INTRO_TXT = {
    random: ':x random',
    first: 'the first :x',
    last: 'the last :x',
    shortest: 'the :x shortest',
    longest: 'the :x longest',
    top: 'the :x most liked'
  }.freeze
  SHOW_SORT = {
    random: %i[date asc],
    first: %i[date asc],
    last: %i[date desc],
    shortest: %i[duration asc],
    longest: %i[duration desc],
    top: %i[likes_count desc]
  }.freeze
  TRACK_SORT = {
    random: %i[show_date asc],
    first: %i[show_date asc],
    last: %i[show_date desc],
    shortest: %i[duration asc],
    longest: %i[duration desc],
    top: %i[likes_count desc]
  }.freeze
  KEYWORDS = {
    random: %w[random any],
    first: %w[first debut],
    last: %w[last recent latest],
    shortest: %w[shortest],
    longest: %w[longest],
    top: %w[top liked best]
  }.freeze

  def self.keywords
    KEYWORDS.values.flatten
  end

  def call
    parse_input
    return show_list if entity == :show
    return track_list if entity == :track
    return song_track_list if entity == :song
    default_response
  end

  private

  attr_reader :words, :count, :entity, :song, :selector

  def parse_input
    @selector = KEYWORDS.find { |_k, v| v.include?(keyword) }.first
    @words = option.split(/\s+/)
    @count, @entity = extract_filters
    @count = [MAX_COUNT, count].min
  end

  def extract_filters # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/LineLength, Metrics/MethodLength, Metrics/PerceivedComplexity
    return [1, :show] if words.none?

    if keyword_specified?
      return [specified_count, specified_keyword] if count_specified?
      return [words.first.in?(%w[show track]) ? 1 : 5, specified_keyword]
    end

    # Song match on all words (command `top 46 days`)
    @song = song_match(option)
    return [count_specified? ? specified_count : 1, :song] if song

    # Song match on all but first word ("46 days" from command `top 5 46 days`)
    @song = song_match(words.drop(1).join(' '))
    return [specified_count, :song] if song

    # If plural like "hoods", try singularized version
    if option.end_with?('s')
      term = count_specified? ? words.drop(1).join(' ') : option
      @song = song_match(term.delete_suffix('s'))
      return [count_specified? ? specified_count : 5, :song] if song
    end

    [specified_count, :error]
  end

  def keyword_specified?
    @keyword_specified ||= specified_keyword.in?(%i[show track])
  end

  def specified_keyword
    @specified_keyword ||=
      case words.last
      when 'show', 'shows'
        :show
      when 'track', 'tracks'
        :track
      else
        :song
      end
  end

  def specified_count
    @specified_count ||= words.first.to_i
  end

  def count_specified?
    @count_specified ||= specified_count.positive?
  end

  def default_response
    "I heard the `#{keyword}` keyword, but I don't understand *\"#{option}\"*"
  end

  def shows
    return random_shows if random?
    @shows ||= Phishin::Client.call(
      'shows',
      params: {
        sort_attr: SHOW_SORT[selector].first,
        sort_dir: SHOW_SORT[selector].second,
        per_page: count
      }
    )
  end

  def random_shows
    @random_shows ||= Array.new(count) { Phishin::Client.call('random-show') }
  end

  def count_or_word
    if single?
      return 'a' if random?
      return ''
    end
    count.to_s
  end

  def intro_txt(phrase)
    str = 'Here'
    str += single? ? "'s" : ' are'
    str += ' ' + [descriptor, simple_pluralize(count, phrase)].join(' ')
    str += ':'
    str + (single? ? ' ' : "\n")
  end

  def descriptor
    INTRO_TXT[selector].gsub(':x', count_or_word).split(/\s+/).join(' ')
  end

  def single?
    count == 1
  end

  def random?
    selector == :random
  end

  def tracks
    @tracks ||= Phishin::Client.call(
      'tracks',
      params: {
        sort_attr: track_sort_attr,
        sort_dir: track_sort_dir,
        per_page: count
      }
    )
  end

  def track_sort_attr
    @track_sort_attr ||= TRACK_SORT[selector].first
  end

  def track_sort_dir
    @track_sort_dir ||= TRACK_SORT[selector].second
  end

  def show_list
    str = intro_txt('show')
    shows.each_with_index do |show, idx|
      str += list_num(idx)
      str += show_info(show)
      likes = show.likes_count
      str += "with *#{number_with_delimiter(likes)} likes* " if likes.positive?
      str += "#{show_link(show)}\n"
    end
    str
  end

  def track_list
    str = intro_txt('track')
    tracks.each_with_index do |track, idx|
      str += list_num(idx)
      str += "*#{track.title}* performed on *#{pretty_date(track.show_date)}* "
      str += track_suffix(track)
    end
    str
  end

  def song_track_list
    str = intro_txt("*#{song.title}* performance")
    song_tracks.each_with_index do |track, idx|
      show = show_on_date(track.show_date)
      str += list_num(idx)
      str += show_info(show)
      str += track_suffix(track)
    end
    str
  end

  def track_suffix(track)
    str = ''
    str +=
      case selector
      when :top
        "with *#{number_with_delimiter(track.likes_count)} likes* " if track.likes_count.positive?
      when :longest, :shortest
        "lasting *#{readable_duration(track.duration, style: 'letters')}* "
      end.to_s
    str + track_link(track) + "\n"
  end

  def list_num(idx)
    return '' if single?
    "#{idx + 1}. "
  end

  def show_info(show)
    "*#{pretty_date(show.date)}* @ *#{show.venue_name}* "
  end

  def song_tracks
    tracks = song.tracks.sort_by { |t| t.send(track_sort_attr) }
    tracks.reverse! if track_sort_dir == :desc
    return tracks.sample(count) if random?
    tracks.first(count)
  end
end
