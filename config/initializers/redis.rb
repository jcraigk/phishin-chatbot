# frozen_string_literal: true
require 'redis'
RedisClient = Redis.new(url: ENV['IN_DOCKER'] ? ENV['REDIS_URL'] : 'redis://localhost:6379')
