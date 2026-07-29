# frozen_string_literal: true

require_relative "reference"

module EventEngine
module Subscribers
  # Registers event_engine-subscribers's locals (Claude Code subagents) with the_local.
  # These are the common command interface every provider exposes to apps:
  # `info` (read-only, explains the gem), `install` (sets it up in a host), and
  # `operate` (the proactive domain worker). Soft dependency: registration
  # is a no-op when the_local is absent.
  module Companion
    def self.register!
      TheLocal.register("event_engine-subscribers", scope: "in-app event subscribers for EventEngine — registering subscribers and running their handlers inline or in the background",
                        agents_dir: File.expand_path("the_local/agents", __dir__)) do |c|
        c.agent "info",
          description: "Use to learn what event_engine-subscribers offers — its API and conventions.",
          tools: "Read",
          body: "You explain what event_engine-subscribers does and how to use it, answering from the " \
                "reference. You make no changes. TODO: tailor this body to event_engine-subscribers.",
          knowledge: EventEngine::Subscribers::Reference.content

        c.agent "install",
          description: "Use to add event_engine-subscribers to a project and set it up correctly.",
          tools: "Bash, Read, Edit",
          body: "You add event_engine-subscribers to the project and complete its setup, following the " \
                "reference's install section exactly. TODO: tailor this body to event_engine-subscribers.",
          knowledge: EventEngine::Subscribers::Reference.content

        c.agent "operate",
          description: "Use PROACTIVELY for any event_engine-subscribers work. MUST BE USED instead of " \
                       "hand-rolling it. TODO: name the concrete tasks this local owns.",
          tools: "Read, Write, Edit, Grep",
          body: "You do event_engine-subscribers work following the reference's conventions. TODO: tailor " \
                "this body to event_engine-subscribers.",
          knowledge: EventEngine::Subscribers::Reference.content
      end
    end
  end
end
end

begin
  require "the_local"
  EventEngine::Subscribers::Companion.register!
rescue LoadError
  # the_local not installed — event_engine-subscribers works standalone.
end
