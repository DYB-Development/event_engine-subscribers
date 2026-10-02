require "test_helper"
require "open3"
require "tmpdir"

class BackgroundEventsWithoutTheCheckTest < ActiveSupport::TestCase
  test "an app that does not call the event start check starts with an event routed to the background" do
    Dir.mktmpdir do |dir|
      rules = File.join(dir, "event_rules.yml")
      File.write(rules, { "events" => { "cow_fed" => "background" } }.to_yaml)

      output, status = Open3.capture2e({ "RAILS_ENV" => "development", "EVENT_ENGINE_RULES" => rules }, "bin/rails", "runner", "print :started", chdir: File.expand_path("../dummy", __dir__))

      assert status.success?, output
    end
  end
end
