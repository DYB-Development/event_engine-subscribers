require "test_helper"

class GemspecTest < ActiveSupport::TestCase
  test "the gem takes no dependency on hub_kernel" do
    spec = Gem::Specification.load(File.expand_path("../event_engine-subscribers.gemspec", __dir__))

    assert_not_includes spec.dependencies.map(&:name), "hub_kernel"
  end
end
