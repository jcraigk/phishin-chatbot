# frozen_string_literal: true
class Oauth::SlackController < ApplicationController
  def code_grant
    TeamRegistrar.call(
      platform: :slack,
      id: oauth_data[:team_id],
      name: team_name,
      bot_user_id: oauth_data[:bot][:bot_user_id],
      token: oauth_data[:bot][:bot_access_token]
    )

    redirect_to success_path(platform: :slack, team: team_name)
  end

  private

  def oauth_data
    return if params[:code].blank?

    @oauth_data ||=
      Slack::Web::Client.new.oauth_access(
        client_id: ENV['SLACK_CLIENT_ID'],
        client_secret: ENV['SLACK_CLIENT_SECRET'],
        code: params[:code]
      ).deep_symbolize_keys
  end

  def team_name
    @team_name ||= oauth_data[:team_name]
  end
end
