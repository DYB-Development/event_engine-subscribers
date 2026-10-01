module EventEngine
  module Subscribers
    # In-memory registry mapping event names to their subscriber classes.
    # Populated at load time (subscribers self-register via {Base.subscribes_to})
    # and consulted when an event is dispatched, so the handler can invoke each
    # subscriber's +#handle(event)+ in the process type's execution context.
    class Registry
      # Registers a subscriber class for an event.
      #
      # @param event_name [Symbol, String] the event to subscribe to
      # @param subscriber [Class] a class responding to +#handle(event)+
      # @return [void]
      def self.register(event_name, subscriber)
        registrations[event_name.to_sym] ||= []
        registrations[event_name.to_sym] << subscriber
      end

      # Returns the subscriber classes registered for an event.
      #
      # @param event_name [Symbol, String]
      # @return [Array<Class>]
      def self.subscribers_for(event_name)
        registrations[event_name&.to_sym] || []
      end

      def self.unsubscribed(routes)
        routes.select { |event_name, process_type| routed_to_subscribers?(process_type) && subscribers_for(event_name).empty? }.keys
      end

      def self.routed_to_subscribers?(process_type) = Processor::HANDLED_PROCESS_TYPES.include?(process_type&.to_sym)
      private_class_method :routed_to_subscribers?

      # Removes all registrations. Intended for test isolation.
      #
      # @return [void]
      def self.clear!
        @registrations = {}
      end

      def self.registrations
        @registrations ||= {}
      end
      private_class_method :registrations
    end
  end
end
