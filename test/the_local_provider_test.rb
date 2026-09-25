require "test_helper"

class TheLocalProviderTest < ActiveSupport::TestCase
  GEM_ROOT = File.expand_path("..", __dir__)

  test "the trio of locals is committed" do
    assert_equal %w[event_engine-subscribers-develop.md event_engine-subscribers-info.md event_engine-subscribers-install.md],
                 Dir.children(File.join(GEM_ROOT, "the_local", "agents")).sort
  end
end
