require "event_engine/subscribers/version"
require "event_engine/subscribers/engine"
require "event_engine/subscribers/registry"
require "event_engine/subscribers/base"
require "event_engine/subscribers/processor"
require "event_engine/subscribers/unsubscribed_events_error"

module EventEngine
  module Subscribers
    def self.routes
      EventEngine.schema_registry.events.to_h { |event_name| [ event_name, process_type_of(event_name) ] }
    end

    def self.process_type_of(event_name)
      domain = EventEngine.schema_registry.latest_for(event_name).domain
      EventEngine.processing_rules.for(event_name: event_name, pack: domain)
    end
    private_class_method :process_type_of

    def self.check!(routes)
      unsubscribed = Registry.unsubscribed(routes)
      raise UnsubscribedEventsError, unsubscribed if unsubscribed.any?

      true
    end

    def self.check_inline!(routes)
      EventEngine.validate_rules!

      true
    end
  end
end
