# frozen_string_literal: true
class TeamsController < ApplicationController
  DEFAULT_INACTIVE_SECONDS = 1_209_600 # 2 weeks

  def purge_inactive
    Team.where(active: true).find_each do |team|
      next if team.last_event_at > Time.current - inactive_seconds
      team.update(active: false)
    end

    head :no_content
  end

  private

  def inactive_seconds
    (params[:inactive_seconds] || DEFAULT_INACTIVE_SECONDS).to_i.seconds
  end
end
