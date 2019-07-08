# frozen_string_literal: true
class Websockets::Manager
  attr_reader :sockets

  MAX_SOCKETS = 250

  def initialize
    @sockets = []
  end

  def start_all
    open_discord_socket
    open_slack_sockets
  end

  def stop_all
    sockets.each { |s| Thread.kill(s.thread) }
  rescue TypeError
    false
  end

  def add(team)
    return if team.discord? # Handled through existing websocket
    return if max_sockets_open? || socket_already_open?(team)
    open_slack_socket(team)
  end

  def remove(team)
    return if team.discord? # Handled through existing websocket
    return unless (thread = sockets.find { |s| s.team_id == team.id }&.thread)
    puts "--- CLOSING SOCKET for Slack / #{team.name}"
    Thread.kill(thread)
    sockets.delete_if { |s| s.team_id == team.id }
  rescue TypeError
    false
  end

  private

  def open_slack_sockets
    Team.where(platform: :slack, active: true)
        .order(:id)
        .limit(MAX_SOCKETS)
        .find_each do |team|
      open_slack_socket(team)
    end
  end

  def open_slack_socket(team)
    return if Rails.env.test? || ENV['NOSOCKETS'].present?
    puts "--- OPENING SOCKET for Slack / #{team.name}"
    @sockets << OpenStruct.new(team_id: team.id, thread: Websockets::Slack.new_thread(team))
  end

  def open_discord_socket
    return if Rails.env.test? || ENV['NOSOCKETS'].present?
    puts "--- OPENING SOCKET for Discord (all authorized guilds)"
    @sockets << OpenStruct.new(team_id: 'discord', thread: Websockets::Discord.new_thread)
  end

  def max_sockets_open?
    sockets.size >= MAX_SOCKETS
  end

  def socket_already_open?(team)
    sockets.any? { |s| s.team_id == team.id }
  end
end
