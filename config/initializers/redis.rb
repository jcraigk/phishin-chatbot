# frozen_string_literal: true
require 'redis'
RedisClient = Redis.new(url: ENV['IN_DOCKER'] ? 'redis://redis:6379' : 'redis://localhost:6379')
