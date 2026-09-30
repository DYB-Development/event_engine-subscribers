require "test_helper"
require "open3"

class SubscribersAcrossReloadsTest < ActiveSupport::TestCase
  test "a subscriber loaded again after a reload is registered once" do
    count = in_development(<<~RUBY)
      RecordCowFed
      Rails.application.reloader.reload!
      RecordCowFed
      print EventEngine::Subscribers::Registry.subscribers_for(:cow_fed).size
    RUBY

    assert_equal "1", count
  end

  private

  def in_development(script)
    output, status = Open3.capture2({ "RAILS_ENV" => "development" }, "bin/rails", "runner", script, chdir: File.expand_path("../dummy", __dir__))
    assert status.success?, output
    output.lines.last
  end
end
