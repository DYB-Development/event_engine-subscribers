module EventEngine
  module Subscribers
    class UnsubscribedEventsError < StandardError
      def initialize(event_names)
        super("These events are routed to subscribers but have none: #{event_names.join(", ")}")
      end
    end
  end
end
