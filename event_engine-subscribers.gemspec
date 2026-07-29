require_relative "lib/event_engine/subscribers/version"

Gem::Specification.new do |spec|
  spec.name        = "event_engine-subscribers"
  spec.version     = EventEngine::Subscribers::VERSION
  spec.authors     = [ "tylercschneider" ]
  spec.email       = [ "tylercschneider@gmail.com" ]
  spec.homepage    = "https://github.com/DYB-Development/event_engine-subscribers"
  spec.summary     = "In-app subscriber execution for EventEngine"
  spec.description = "The subscriber layer for EventEngine: runs your in-app subscribers for events routed to it. Registers itself with the event_engine runtime as the :inline and :background processors, running subscribers synchronously or in a background job depending on which one an event's rule names."
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/tylercschneider/event_engine-subscribers/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/tylercschneider/event_engine-subscribers/issues"
  spec.metadata["documentation_uri"] = "https://github.com/tylercschneider/event_engine-subscribers#readme"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "railties", ">= 7.1.6", "< 9"
  spec.add_dependency "activejob", ">= 7.1.6", "< 9"
  spec.add_dependency "event_engine", ">= 0.2.0"
end
