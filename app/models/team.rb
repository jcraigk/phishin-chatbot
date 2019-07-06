# frozen_string_literal: true
class Team < ApplicationRecord
  enum platform: {
    slack: 0,
    discord: 1
  }

  validates :remote_id, presence: true, uniqueness: { scope: :platform }
  validates :name, presence: true, uniqueness: { scope: :platform }
  validates :token, presence: true, uniqueness: { scope: :platform }

  after_create_commit :open_websocket
  after_update_commit :close_websocket_if_inactive
  after_destroy_commit :close_websocket

  private

  def open_websocket
    SocketManager.add(self)
  end

  def close_websocket_if_inactive
    return unless saved_changes.key?(:active) && !active
    close_websocket
  end

  def close_websocket
    puts "HERE HERE HERE"
    SocketManager.remove(self)
  end
end
