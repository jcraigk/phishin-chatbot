# frozen_string_literal: true
class TeamRegistrar
  attr_reader :platform, :id, :name, :token, :token_expires_at, :refresh_token

  def initialize(opts = {})
    @platform = opts[:platform]
    @id = opts[:id]
    @name = opts[:name]
    @token = opts[:token]
    @token_expires_at = opts[:token_expires_at]
    @refresh_token = opts[:refresh_token]
  end

  def self.call(opts = {})
    new(opts).call
  end

  def call
    register_team
    initiate_websocket
  end

  private

  def initiate_websocket
    # TODO: Websocket management
    # bot = Discordrb::Bot.new(token: @bot_token)
    # app_data = Discordrb::Bot.bot_app
  end

  def token_attrs
    {
      token: token,
      token_expires_at: token_expires_at,
      refresh_token: refresh_token
    }.compact
  end

  def register_team
    return existing_team.update(token_attrs.merge(active: true)) if existing_team
    Team.create!(token_attrs.merge(platform: platform, remote_id: id, name: name))
  end

  def existing_team
    @team ||=
      Team.where(platform: platform, token: token)
          .or(Team.where(platform: platform, remote_id: id))
          .first
  end
end
