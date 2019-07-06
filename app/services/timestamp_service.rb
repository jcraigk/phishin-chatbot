# frozen_string_literal: true
class TimestampService
  def register(team_id)
    RedisClient.set(timestamp_key(team_id), Time.current.to_i)
  end

  private

  def timestamp_key(team_id)
    "last_event_timestamp/#{team_id}"
  end
end
