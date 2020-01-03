# frozen_string_literal: true
module Websockets; end

class Websockets::Manager
  attr_reader :sockets

  MAX_SOCKETS = 250

  def initialize
    @sockets = []
  end

  def start_all
    return unless open_chat_sockets?
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

    Rails.logger.info("--- CLOSING SOCKET for Slack / #{team.name}")
    Thread.kill(thread)
    sockets.delete_if { |s| s.team_id == team.id }
  rescue TypeError
    false
  end

  private

  def open_chat_sockets?
    !Rails.env.test? && (ENV['IN_DOCKER'].present? || ENV['CHAT_SOCKETS'].present?)
  end

  def open_slack_sockets
    return unless open_chat_sockets?
    Team.where(platform: :slack, active: true)
        .order(:id)
        .limit(MAX_SOCKETS)
        .find_each do |team|
      open_slack_socket(team)
    end
  end

  def open_slack_socket(team)
    return unless open_chat_sockets?
    Rails.logger.info("--- OPENING SOCKET for Slack / (#{team.name})")
    @sockets << OpenStruct.new(team_id: team.id, thread: Websockets::Slack.new_thread(team))
  end

  def open_discord_socket
    return unless open_chat_sockets?
    Rails.logger.info('--- OPENING SOCKET for Discord (all guilds)')
    @sockets << OpenStruct.new(team_id: 'discord', thread: Websockets::Discord.new_thread)
  end

  def max_sockets_open?
    sockets.size >= MAX_SOCKETS
  end

  def socket_already_open?(team)
    sockets.any? { |s| s.team_id == team.id }
  end
end
