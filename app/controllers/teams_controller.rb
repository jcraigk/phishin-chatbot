# frozen_string_literal: true
class TeamsController < ApplicationController
  def purge_inactive
    Team.where(active: true).find_each do |team|
      next if team.last_event_at > Time.current - inactive_seconds
      team.disable
    end

    head :no_content
  end

  private

  def inactive_seconds
    (params[:inactive_seconds] || Rails.configuration.inactive_seconds).to_i.seconds
  end
end
