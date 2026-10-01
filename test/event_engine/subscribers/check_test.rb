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
    end
  end
end
