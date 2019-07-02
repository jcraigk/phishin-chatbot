# frozen_string_literal: true

# TODO: refresh_token / rotation
class Oauth::DiscordController < ApplicationController
  def code_grant
    TeamRegistrar.call(
      platform: :discord,
      id: oauth_data[:guild][:id],
      name: team_name,
      token: oauth_data[:access_token],
      token_expires_at: token_expires_at,
      refresh_token: oauth_data[:refresh_token]
    )

    redirect_to success_path(platform: :discord, team: team_name)
  end

  private

  def oauth_data
    @oauth_data ||= JSON[HTTP.post(oauth_url, form: oauth_params)].deep_symbolize_keys
  end

  def oauth_url
    "#{ENV['DISCORD_API_ENDPOINT']}/oauth2/token"
  end

  def oauth_params
    {
      'client_id': ENV['DISCORD_CLIENT_ID'],
      'client_secret': ENV['DISCORD_CLIENT_SECRET'],
      'grant_type': 'authorization_code',
      'code': params[:code],
      'redirect_uri': ENV['DISCORD_REDIRECT_URI'],
      'scope': 'bot'
    }
  end

  def token_expires_at
    Time.current + oauth_data[:expires_in].to_i.seconds
  end

  def team_name
    @team_name ||= oauth_data[:guild][:name]
  end
end
