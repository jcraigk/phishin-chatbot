# frozen_string_literal: true
require './app/services/websockets/manager'
require './app/services/websockets/discord'
require './app/services/websockets/slack'
require './app/models/application_record'
require './app/models/team'

SocketManager = Websockets::Manager.new
SocketManager.start_all
