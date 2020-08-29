#!/usr/bin/env ruby
require 'websocket-client-simple'
require 'xlog'
require 'pry'
require 'eventmachine'
require './amqp'
require 'json'


class SocketClient
  CRYPTO_MARKET = 'wss://stream.globitex.com/market-data'.freeze

  def initialize
    @socket = WebSocket::Client::Simple.connect CRYPTO_MARKET
  end

  def establish_connection
    begin
      receive_messages
    rescue Interrupt => _
      close_connection
    end
  end

  private

  def receive_messages
    EM::run do
      puts 'Server started'
      log '[*] Waiting for messages. To exit press CTRL+C'
      @socket.on :message do |msg|
        Rabbit::Amqp.publish('crypto_test', JSON.parse(msg.data))
        Xlog.info msg.data
      end
    end
  end

  def close_connection
    log 'Connection closed'
    puts 'Server stopped'
    exit 1
  end

  def log(message)
    Xlog.info(message)
  end
end

SocketClient.new.establish_connection



