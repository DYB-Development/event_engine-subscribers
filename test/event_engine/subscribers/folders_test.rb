require "test_helper"
require "tmpdir"

class EventEngine::Subscribers::FoldersTest < ActiveSupport::TestCase
  test "names folders and folder patterns relative to the host's root" do
    Dir.mktmpdir do |dir|
      root = Pathname.new(dir)
      expected = %w[extra/subscribers hubs/barn/app/subscribers hubs/field/app/subscribers].map { |folder| root.join(folder).tap(&:mkpath) }

      assert_equal expected, EventEngine::Subscribers.folders_matching(root, [ "extra/subscribers", "hubs/*/app/subscribers" ])
    end
  end
end
