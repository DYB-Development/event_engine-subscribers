require "test_helper"

module EventEngine
  module Subscribers
    class RegistryTest < ActiveSupport::TestCase
      class FakeSubscriber; end

      setup do
        Registry.clear!
      end

      teardown do
        Registry.clear!
      end

      test "registers a subscriber retrievable by event name" do
        Registry.register(:cow_fed, FakeSubscriber)

        assert_includes Registry.subscribers_for(:cow_fed), FakeSubscriber
      end

      test "returns an empty array for an event with no subscribers" do
        assert_equal [], Registry.subscribers_for(:never_registered)
      end

      test "returns an empty array for a nil event name" do
        assert_equal [], Registry.subscribers_for(nil)
      end

      test "names an event routed to subscribers that has none" do
        assert_equal [ :cow_fed ], Registry.unsubscribed(cow_fed: :inline)
      end

      test "leaves out an event routed to subscribers that has one" do
        Registry.register(:cow_fed, FakeSubscriber)

        assert_empty Registry.unsubscribed(cow_fed: :inline)
      end

      test "leaves out an event routed somewhere other than subscribers" do
        assert_empty Registry.unsubscribed(cow_fed: :audit_log)
      end
    end
  end
end
