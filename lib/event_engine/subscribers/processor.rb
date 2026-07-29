module EventEngine
  module Subscribers
    class Processor
      HANDLED_PROCESS_TYPES = [ :inline, :background ].freeze

      def call(event)
        case event.process_type&.to_sym
        when :inline then dispatch_synchronously(event)
        when :background then dispatch_in_background(event)
        end
      end

      private

      def dispatch_synchronously(event)
        Registry.subscribers_for(event.event_name).each { |subscriber| subscriber.new.handle(event) }
        event
      end

      def dispatch_in_background(event)
        DispatchSubscribersJob.perform_later(event.event_name.to_s, event.to_h)
        event
      end
    end
  end
end
