require "test_helper"

module EventEngine
  module Subscribers
    class CheckTest < ActiveSupport::TestCase
      setup { Registry.clear! }
      teardown { Registry.clear! }

      test "refuses to go on while an event routed to subscribers has none, and names it" do
        refusal = assert_raises(UnsubscribedEventsError) { Subscribers.check!(cow_fed: :inline, hay_baled: :background) }

        assert_equal "These events are routed to subscribers but have none: cow_fed, hay_baled", refusal.message
      end

      test "the routes are each catalogued event and the process type its rule gives it" do
        schemas = Object.new
        def schemas.events = [ :cow_fed ]
        def schemas.latest_for(_event_name, domain: nil) = Struct.new(:domain).new(:farm)

        with_event_engine(schemas, ProcessingRules.new(packs: { farm: :inline })) do
          assert_equal({ cow_fed: :inline }, Subscribers.routes)
        end
      end

      private

      def with_event_engine(schemas, rules)
        kept = [ EventEngine.schema_registry, EventEngine.processing_rules ]
        EventEngine.schema_registry, EventEngine.processing_rules = schemas, rules
        yield
      ensure
        EventEngine.schema_registry, EventEngine.processing_rules = kept
      end
    end
  end
end
