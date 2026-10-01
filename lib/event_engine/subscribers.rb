require "event_engine/subscribers/version"
require "event_engine/subscribers/engine"
require "event_engine/subscribers/registry"
require "event_engine/subscribers/base"
require "event_engine/subscribers/processor"
require "event_engine/subscribers/unsubscribed_events_error"

module EventEngine
  module Subscribers
    # Raises {UnsubscribedEventsError} naming every event routed to subscribers
    # that has none registered.
    #
    # @param routes [Hash{Symbol=>Symbol}] each event name and the process type it is routed to
    # @return [true]
    # Each event in event_engine's catalog and the process type its rule routes it to.
    #
    # @return [Hash{Symbol=>Symbol}]
    def self.routes
      schemas = EventEngine.schema_registry
      schemas.events.to_h { |event_name| [ event_name, EventEngine.processing_rules.for(event_name: event_name, pack: schemas.latest_for(event_name).domain) ] }
    end

    def self.check!(routes)
      unsubscribed = Registry.unsubscribed(routes)
      raise UnsubscribedEventsError, unsubscribed if unsubscribed.any?

      true
    end
  end
end
