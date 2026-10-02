module EventEngine
  module Subscribers
    class BackgroundEventsError < StandardError
      def initialize(event_names)
        super("These events are routed to run in the background, where a refusal cannot undo the change: #{event_names.join(", ")}")
      end
    end
  end
end
