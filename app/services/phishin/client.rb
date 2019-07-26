# frozen_string_literal: true
class Phishin::Client
  BASE_URL = 'https://phish.in/api/v1'
  DEFAULT_PARAMS = { page: 1, per_page: 10 }.freeze
  TIMEOUT = 10

  attr_reader :api_path, :opts

  def initialize(api_path, opts = {})
    @api_path = api_path
    @opts = opts
  end

  def call
    fetch_cached_data
  end

  def self.call(api_path, opts = {})
    new(api_path, opts).call
  end

  private

  def param_str
    DEFAULT_PARAMS.merge(opts[:params] || {}).to_query
  end

  def fetch_cached_data
    return fetch_data if url.include?('random') # Don't cache `random` URLs
    Rails.cache.fetch(url, expires_in: Rails.configuration.cache_ttl) { fetch_data }
  end

  def fetch_data
    JSON.parse(http_get.body, object_class: OpenStruct).data
  end

  def http_get
    HTTP.timeout(TIMEOUT)
        .accept(:json)
        .auth("Bearer #{ENV['PHISHIN_API_KEY']}")
        .get(url)
  end

  def url
    "#{BASE_URL}/#{api_path}?#{param_str}"
  end
end
