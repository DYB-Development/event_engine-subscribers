require "test_helper"
require "event_engine/subscribers/background_events_error"

module EventEngine
  module Subscribers
    class BackgroundEventsErrorTest < ActiveSupport::TestCase
      test "names every event routed to the background" do
        assert_equal "These events are routed to run in the background, where a refusal cannot undo the change: cow_fed, hay_baled", BackgroundEventsError.new([ :cow_fed, :hay_baled ]).message
      end
    end
  end
end
