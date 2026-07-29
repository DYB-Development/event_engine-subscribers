require "test_helper"

module EventEngine
  module Subscribers
    class ProcessorTest < ActiveSupport::TestCase
      include ActiveJob::TestHelper

      teardown { Registry.clear! }

      test "enqueues a job for a :background event" do
        event = EventEngine::Event.new(event_name: :cow_fed, process_type: :background)

        assert_enqueued_with(job: DispatchSubscribersJob) do
          Processor.new.call(event)
        end
      end

      test "runs subscribers synchronously for an :inline event" do
        handled = []
        subscriber = Class.new { define_method(:handle) { |event| handled << event } }
        Registry.register(:cow_fed, subscriber)
        event = EventEngine::Event.new(event_name: :cow_fed, process_type: :inline)

        Processor.new.call(event)

        assert_equal [ event ], handled
      end
    end
  end
end
