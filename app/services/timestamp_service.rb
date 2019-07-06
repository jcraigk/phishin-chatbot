# frozen_string_literal: true
class TimestampService
  def register_event(team_id)
    RedisClient.set(timestamp_key(team_id), Time.current.to_i)
  end

  def last_timestamp(team_id)
    RedisClient.get(timestamp_key(team_id)).to_i
  end

  private

  def timestamp_key(team_id)
    "last_event_timestamp/#{team_id}"
  end
end
