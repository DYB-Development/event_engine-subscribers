require "test_helper"

class ProcessorRegistrationTest < ActiveSupport::TestCase
  test "registers its processor for every process type it handles" do
    registered = EventEngine::Subscribers::Processor::HANDLED_PROCESS_TYPES.map do |process_type|
      EventEngine.processor_registry.fetch(process_type)
    end

    assert registered.all? { |processor| processor.is_a?(EventEngine::Subscribers::Processor) }
  end
end
