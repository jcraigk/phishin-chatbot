# frozen_string_literal: true
class Team < ApplicationRecord
  enum platform: {
    slack: 0,
    discord: 1
  }

  validates :bot_token, presence: true, uniqueness: { scope: :platform }
  validates :bot_user_id, presence: true, uniqueness: { scope: :platform }
  validates :name, presence: true, uniqueness: { scope: :platform }
  validates :team_id, presence: true, uniqueness: { scope: :platform }
  validates :user_id, presence: true, uniqueness: { scope: :platform }
  validates :user_token, presence: true, uniqueness: { scope: :platform }
end
