# frozen_string_literal: true
class Oauth::DiscordController < ApplicationController
  def code_grant
    TeamRegistrar.call(
      platform: :discord,
      id: oauth_data[:guild][:id],
      name: team_name
    )

    redirect_to success_path(platform: :discord, team: team_name)
  end

  private

  def oauth_data
    @oauth_data ||= JSON[HTTP.post(oauth_url, form: oauth_params)].deep_symbolize_keys
  end

  def oauth_url
    'https://discordapp.com/api/v6/oauth2/token'
  end

  def oauth_params
    {
      'client_id': ENV['DISCORD_CLIENT_ID'],
      'client_secret': ENV['DISCORD_CLIENT_SECRET'],
      'grant_type': 'authorization_code',
      'code': params[:code],
      'scope': 'bot'
    }
  end

  def team_name
    @team_name ||= oauth_data[:guild][:name]
  end
end
