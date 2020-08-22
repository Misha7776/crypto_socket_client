require 'bunny'
# require 'mutex'

module Rabbit
  class Amqp
    class << self
      attr_writer :bunny

      def publish(queue, message = {})
        start_bunny

        channel ||= bunny.create_channel
        # grab the queue
        x = channel.queue(queue, durable: true, persistent: true)
        # and simply publish message
        x.publish(message.to_json)

        sleep 0.5
        channel.close
      end

      def start_bunny
        mutex.synchronize { bunny.start } unless bunny&.connected?
      end

      def bunny
        @bunny ||= Bunny.new(automatically_recover: false)
      end

      def mutex
        @mutex ||= Mutex.new
      end
    end
  end
end
