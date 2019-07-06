# frozen_string_literal: true
SocketManager = Websockets::Manager.new
Timestamper = TimestampService.new
SocketManager.start_all if ENV['WEBSOCKETS'] == 'true'
