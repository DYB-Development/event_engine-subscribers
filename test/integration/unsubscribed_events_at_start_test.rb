require "test_helper"
require "open3"
require "tmpdir"

class UnsubscribedEventsAtStartTest < ActiveSupport::TestCase
  test "the app refuses to start while an event routed to subscribers has none, and names it" do
    Dir.mktmpdir do |dir|
      rules = File.join(dir, "event_rules.yml")
      File.write(rules, { "default" => "inline" }.to_yaml)

      output, status = Open3.capture2e({ "RAILS_ENV" => "development", "EVENT_ENGINE_RULES" => rules }, "bin/rails", "runner", "print :started", chdir: File.expand_path("../dummy", __dir__))

      assert_equal [ false, true ], [ status.success?, output.include?("These events are routed to subscribers but have none: hay_baled") ]
    end
  end
end
