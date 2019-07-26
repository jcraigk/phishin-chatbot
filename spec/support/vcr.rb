# frozen_string_literal: true
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
  c.default_cassette_options = { match_requests_on: %i[method uri body] }
  c.configure_rspec_metadata!
end
