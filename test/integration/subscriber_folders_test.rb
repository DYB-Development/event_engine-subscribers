require "test_helper"
require "open3"
require "tmpdir"

class SubscriberFoldersTest < ActiveSupport::TestCase
  test "a subscriber in a folder the host names is registered when the app starts" do
    count = in_development(<<~RUBY)
      print EventEngine::Subscribers::Registry.subscribers_for(:hay_baled).size
    RUBY

    assert_equal "1", count
  end

  test "a subscriber in a folder the host names is registered once again after a reload" do
    count = in_development(<<~RUBY)
      Rails.application.reloader.reload!
      print EventEngine::Subscribers::Registry.subscribers_for(:hay_baled).size
    RUBY

    assert_equal "1", count
  end

  test "a named folder or pattern that matches no folder does not stop the app from starting" do
    started = in_development("print :started", folders: "missing/subscribers,nowhere/*/subscribers")

    assert_equal "started", started
  end

  test "the start check counts subscribers in the folders the host names" do
    Dir.mktmpdir do |dir|
      rules = File.join(dir, "event_rules.yml")
      File.write(rules, { "default" => "inline" }.to_yaml)

      started = in_development("print :started", env: { "EVENT_ENGINE_RULES" => rules })

      assert_equal "started", started
    end
  end

  private

  def in_development(script, folders: "hubs/*/app/subscribers", env: {})
    output, status = Open3.capture2({ "RAILS_ENV" => "development", "SUBSCRIBER_FOLDERS" => folders, **env }, "bin/rails", "runner", script, chdir: File.expand_path("../dummy", __dir__))
    assert status.success?, output
    output.lines.last
  end
end
