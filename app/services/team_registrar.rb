# frozen_string_literal: true
class TeamRegistrar
  attr_reader :platform, :id, :name, :bot_user_id, :token

  def initialize(opts = {})
    @platform = opts[:platform]
    @id = opts[:id]
    @name = opts[:name]
    @bot_user_id = opts[:bot_user_id]
    @token = opts[:token]
  end

  def self.call(opts = {})
    new(opts).call
  end

  def call
    register_team
  end

  private

  def register_team
    return existing_team.update(auth_attrs.merge(active: true)) if existing_team
    Team.create!(auth_attrs.merge(identity_attrs))
  end

  def auth_attrs
    {
      bot_user_id: bot_user_id,
      token: token
    }.compact
  end

  def identity_attrs
    {
      platform: platform,
      remote_id: id,
      name: name
    }
  end

  def existing_team
    @existing_team ||= Team.find_by(platform: platform, remote_id: id)
  end
end
