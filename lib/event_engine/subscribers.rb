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
    def self.check!(routes)
      unsubscribed = Registry.unsubscribed(routes)
      raise UnsubscribedEventsError, unsubscribed if unsubscribed.any?

      true
    end
  end
end
