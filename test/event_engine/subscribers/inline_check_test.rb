require "test_helper"

module EventEngine
  module Subscribers
    class InlineCheckTest < ActiveSupport::TestCase
      test "refuses to go on while an event has no rule, and names it" do
        with_event_engine(ProcessingRules.new(events: { hay_baled: :inline })) do
          assert_raises(EventEngine::UnroutedEventsError, match: ":cow_fed") { Subscribers.check_inline!(Subscribers.routes) }
        end
      end

      test "refuses to go on while a rule names a processor nothing registered, and names it" do
        with_event_engine(ProcessingRules.new(default: :carrier_pigeon)) do
          assert_raises(EventEngine::InvalidRulesError, match: "carrier_pigeon") { Subscribers.check_inline!(Subscribers.routes) }
        end
      end

      test "refuses to go on while events are routed to the background, and names every one" do
        with_event_engine(ProcessingRules.new(default: :background)) do
          assert_raises(BackgroundEventsError, match: "cow_fed, hay_baled") { Subscribers.check_inline!(Subscribers.routes) }
        end
      end

      test "refuses only background events in the packs named as inline" do
        with_event_engine(ProcessingRules.new(default: :background)) do
          assert_raises(BackgroundEventsError, match: /change: cow_fed\z/) { Subscribers.check_inline!(Subscribers.routes, packs: [ :farm ]) }
        end
      end

      private

      def with_event_engine(rules)
        schemas = Object.new
        def schemas.events = [ :cow_fed, :hay_baled ]
        def schemas.latest_for(event_name, domain: nil) = Struct.new(:domain).new(event_name == :hay_baled ? :barn : :farm)

        kept = [ EventEngine.schema_registry, EventEngine.processing_rules ]
        EventEngine.schema_registry, EventEngine.processing_rules = schemas, rules
        yield
      ensure
        EventEngine.schema_registry, EventEngine.processing_rules = kept
      end
    end
  end
end
