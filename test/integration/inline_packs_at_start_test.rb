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

  test "the inline check sees a processor registered in a start-up hook that runs after the gem's own" do
    Dir.mktmpdir do |dir|
      rules = File.join(dir, "event_rules.yml")
      File.write(rules, { "events" => { "cow_fed" => "inline", "hay_baled" => "durable" } }.to_yaml)

      output, status = Open3.capture2e({ "RAILS_ENV" => "development", "EVENT_ENGINE_RULES" => rules, "INLINE_PACKS" => "barn" }, "bin/rails", "runner", "print :started", chdir: File.expand_path("../dummy", __dir__))

      assert status.success?, output
    end
  end
end
