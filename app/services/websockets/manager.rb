# frozen_string_literal: true
class Websockets::Manager
  attr_reader :sockets

  MAX_SOCKETS = 250

  def initialize
    @sockets = []
  end

  def start_all
    Team.where(active: true)
        .order(:id)
        .limit(MAX_SOCKETS)
        .find_each do |team|
      open_websocket(team)
    end
  end

  def stop_all
    sockets.each { |s| Thread.kill(s.thread) }
  rescue TypeError
    false
  end

  def add(team)
    return if max_sockets_open? || socket_already_open?(team)
    open_websocket(team)
  end

  def remove(team)
    return unless (thread = sockets.find { |s| s.team_id == team.id }&.thread)
    puts "--- CLOSING #{log_suffix(team)}"
    Thread.kill(thread)
  rescue TypeError
    false
  end

  private

  def max_sockets_open?
    sockets.size >= MAX_SOCKETS
  end

  # TODO: report to Sentry if max_sockets_open
  def socket_already_open?(team)
    sockets.any? { |s| s.team_id == team.id }
  end

  def open_websocket(team)
    @sockets << OpenStruct.new(team_id: team.id, thread: new_thread(team))
  end

  def new_thread(team)
    return unless ENV['WEBSOCKETS'] == 'true'
    puts "--- OPENING #{log_suffix(team)}"
    "Websockets::#{team.platform.titleize}".constantize.new_thread(team)
  end

  def log_suffix(team)
    "websocket for Slack team #{team.name}"
  end
end
