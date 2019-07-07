# frozen_string_literal: true
class Team < ApplicationRecord
  enum platform: {
    slack: 0,
    discord: 1
  }

  validates :remote_id, presence: true, uniqueness: { scope: :platform }
  validates :name, presence: true, uniqueness: { scope: :platform }
  validates :token, presence: true, uniqueness: { scope: :platform }

  after_create_commit :open_chat_connection
  after_update_commit :sync_chat_connection
  after_destroy_commit :close_chat_connection

  def register_event
    RedisClient.set(redis_event_key, Time.current.to_i)
  end

  def last_event_at
    RedisClient.get(redis_event_key).to_i
  end

  private

  def open_chat_connection
    open_websocket if slack?
  end

  def sync_chat_connection
    return unless saved_changes.key?(:active)
    return open_chat_connection if active?
    close_chat_connection
  end

  def close_chat_connection
    return leave_discord_guild if discord?
    close_websocket
  end

  def open_websocket
    SocketManager.add(self)
  end

  def close_websocket
    SocketManager.remove(self)
  end

  def leave_discord_guild
    HTTP.auth("Bot #{ENV['DISCORD_BOT_TOKEN']}")
        .delete("https://discordapp.com/api/v6/users/@me/guilds/#{remote_id}")
  end

  def redis_event_key
    "last_event/#{id}"
  end
end
