# frozen_string_literal: true

# TODO: refresh_token / rotation
class Oauth::SlackController < ApplicationController
  def code_grant
    TeamRegistrar.call(
      platform: :slack,
      id: oauth_data[:team_id],
      name: oauth_data[:team_name],
      token: oauth_data[:bot][:bot_access_token]
    )

    redirect_to success_path(platform: :slack)
  end

  private

  def oauth_data
    @oauth_data ||=
      Slack::Web::Client.new.oauth_access(
        client_id: ENV['SLACK_CLIENT_ID'],
        client_secret: ENV['SLACK_CLIENT_SECRET'],
        code: params[:code]
      ).deep_symbolize_keys
  end
end
