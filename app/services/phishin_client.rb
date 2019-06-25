# frozen_string_literal: true
class PhishinClient
  BASE_URL = 'https://phish.in/api/v1'
  PARAMS = 'page=1&per_page=10000'
  TIMEOUT = 10
  CACHE_TTL = 1.hour

  attr_reader :api_path

  def initialize(api_path)
    @api_path = api_path
  end

  def call
    fetch_data
  end

  def self.call(api_path)
    new(api_path).call
  end

  private

  def fetch_data
    Rails.cache.fetch(url, expires_in: CACHE_TTL) do
      JSON[http_get.body].deep_symbolize_keys[:data]
    end
  end

  def http_get
    HTTP.timeout(TIMEOUT)
        .accept(:json)
        .auth("Bearer #{ENV['PHISHIN_API_KEY']}")
        .get(url)
  rescue HTTP::ConnectionError
    raise NodeConnectionFailure, "Phishin API unreachable at #{url}"
  rescue HTTP::TimeoutError
    raise NodeTimeout, "Node timeout after #{TIMEOUT} seconds"
  end

  def url
    "#{BASE_URL}/#{api_path}?#{PARAMS}"
  end
end
