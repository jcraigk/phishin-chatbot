# frozen_string_literal: true
module Timestamper
  def self.register(platform, id)
    RedisClient.set(key(platform, id), Time.current.to_i)
  end

  def self.lookup(platform, id)
    Time.zone.at(RedisClient.get(key(platform, id)).to_i)
  end

  def self.key(platform, id)
    "timestamps/#{platform}/#{id}"
  end
end
