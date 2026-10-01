module EventEngine
  module Subscribers
    # Raised at start when events routed to subscribers have none registered,
    # so an event the app sends cannot run nothing without anyone knowing.
    class UnsubscribedEventsError < StandardError
      def initialize(event_names)
        super("These events are routed to subscribers but have none: #{event_names.join(", ")}")
      end
    end
  end
end
