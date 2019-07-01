# frozen_string_literal: true
class Team < ApplicationRecord
  validates :name, presence: true
  validates :domain, presence: true
  validates :bot_user_id, presence: true
  validates :bot_token, presence: true
  validates :user_id, presence: true
  validates :user_token, presence: true
end
