require "test_helper"
require "open3"
require "tmpdir"

class InlinePacksAtStartTest < ActiveSupport::TestCase
  test "the app runs the inline check at start-up when the host names packs" do
    Dir.mktmpdir do |dir|
      rules = File.join(dir, "event_rules.yml")
      File.write(rules, { "events" => { "cow_fed" => "background" } }.to_yaml)

      output, status = Open3.capture2e({ "RAILS_ENV" => "development", "EVENT_ENGINE_RULES" => rules, "INLINE_PACKS" => "farm" }, "bin/rails", "runner", "print :started", chdir: File.expand_path("../dummy", __dir__))

      assert_equal [ false, true ], [ status.success?, output.include?("no processing rule routes :hay_baled") ]
    end
  end
end
