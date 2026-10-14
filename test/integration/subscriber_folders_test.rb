require "test_helper"
require "open3"

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

  private

  def in_development(script)
    output, status = Open3.capture2({ "RAILS_ENV" => "development", "SUBSCRIBER_FOLDERS" => "hubs/*/app/subscribers" }, "bin/rails", "runner", script, chdir: File.expand_path("../dummy", __dir__))
    assert status.success?, output
    output.lines.last
  end
end
