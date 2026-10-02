require "test_helper"
require "shellwords"

class EventEngine::Subscribers::EngineTest < ActiveSupport::TestCase
  # Tools like `the_local install` load the gem via a plain Bundler.require, with
  # no Rails boot. The engine subclasses ::Rails::Engine, so the gem must require
  # Rails itself rather than assuming the host has already loaded it.
  test "the gem loads outside a Rails boot" do
    gem_root = File.expand_path("../../..", __dir__)
    script = 'require "event_engine/subscribers"'

    output = Bundler.with_unbundled_env do
      `cd #{gem_root.shellescape} && bundle exec ruby -e #{script.shellescape} 2>&1`
    end

    assert $?.success?, "Loading the gem without Rails failed:\n#{output}"
  end

  test "a host names no packs that must run inline unless it sets them" do
    assert_equal [], Rails.application.config.event_engine_subscribers.inline_packs
  end
end
