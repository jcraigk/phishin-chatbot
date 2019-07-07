# frozen_string_literal: true
namespace :teams do
  desc 'Disable teams inactive for INACTIVE_PERIOD'
  task disable_inactive: :environment do
    # TODO: Maybe make this react to an endpoint since we need access to threads..?
    puts 'Disabling inactive teams...'
    Team.where(active: true).find_each do |team|
      next print '-' if team.last_event_received_at > Time.current - ENV['INACTIVE_SECONDS'].to_i.seconds
      team.update(active: false)
      print '*'
    end

    puts 'done'
  end
end
