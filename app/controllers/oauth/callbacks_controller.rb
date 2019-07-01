# frozen_string_literal: true
class Oauth::CallbacksController < ApplicationController
  def slack
    binding.pry

    client = Slack::Web::Client.new
    response = client.oauth_access(client_id: ENV['SLACK_CLIENT_ID'],client_secret: ENV['SLACK_CLIENT_SECRET'],code: params[:code]).deep_symbolize_keys


    @bot_user_id = response[:bot][:bot_user_id]
    @bot_token = response[:bot][:bot_access_token]
    @user_id = response[:user_id]
    @user_token = response[:access_token]
    @team_id = response[:team_id]
    @team_name = response[:team_name]

    team = team_by_platform(:slack)
    binding.pry

    if team
      team.update!(
        user_id: user_id,
        user_token: user_token,
        bot_user_id: bot_user_id,
        bot_token: bot_token,
        active: true
      )
    else
      team = Team.create!(
        team_id: team_id,
        name: team_name,
        bot_user_id: bot_user_id,
        bot_token: bot_token,
        user_id: user_id,
        user_token: user_token
      )
    end

    # options = params.slice(:state)
    # Service.instance.create!(team, options)
  end

  private

  def team_by_platform(platform)
    Team.where(platform: platform, bot_token: @bot_token).or(Team.where(platform: platform, team_id: team_id))
  end
end
