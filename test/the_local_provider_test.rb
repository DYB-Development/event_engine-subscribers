require "test_helper"

class TheLocalProviderTest < ActiveSupport::TestCase
  GEM_ROOT = File.expand_path("..", __dir__)

  test "the trio of locals is committed" do
    assert_equal %w[event_engine-subscribers-develop.md event_engine-subscribers-info.md event_engine-subscribers-install.md],
                 Dir.children(File.join(GEM_ROOT, "the_local", "agents")).sort
  end

  test "the packaged gem ships the locals" do
    spec = Gem::Specification.load(File.join(GEM_ROOT, "event_engine-subscribers.gemspec"))

    assert_includes spec.files, "the_local/agents/event_engine-subscribers-develop.md"
  end
end
