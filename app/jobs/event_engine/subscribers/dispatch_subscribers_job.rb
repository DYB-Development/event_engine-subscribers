module EventEngine
  module Subscribers
    # Runs an event's subscribers in a background worker. Enqueued by
    # {Processor} for +:background+ events, which dispatch their subscribers
    # asynchronously without touching the outbox.
    class DispatchSubscribersJob < ApplicationJob
      queue_as :default

      # @param event_name [String] the emitted event's name
      # @param attrs [Hash] the event attributes used to rebuild the Event
      # @return [void]
      def perform(event_name, attrs)
        event = EventEngine::Event.new(**attrs.deep_symbolize_keys)
        Registry.subscribers_for(event_name).each { |subscriber| subscriber.new.handle(event) }
      end
    end
  end
end
