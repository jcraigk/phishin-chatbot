# frozen_string_literal: true
class Team < ApplicationRecord
  enum platform: {
    slack: 0,
    discord: 1
  }

  validates :remote_id, presence: true, uniqueness: { scope: :platform }
  validates :name, presence: true, uniqueness: { scope: :platform }
  validates :token, presence: true, uniqueness: { scope: :platform }
end
