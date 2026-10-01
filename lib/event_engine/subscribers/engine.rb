require "rails"

module EventEngine
  module Subscribers
    class Engine < ::Rails::Engine
      isolate_namespace EventEngine::Subscribers

      initializer "event_engine.subscribers.register_processor" do
        config.after_initialize do
          processor = Processor.new
          Processor::HANDLED_PROCESS_TYPES.each do |process_type|
            EventEngine.register_processor(process_type, processor)
          end
        end
      end

      initializer "event_engine.subscribers.check_every_routed_event_has_a_subscriber" do
        config.after_initialize { Subscribers.check!(Subscribers.routes) }
      end

      initializer "event_engine.subscribers.forget_unloaded_subscribers" do |app|
        app.reloader.before_class_unload { Registry.clear! }
      end

      initializer "event_engine.subscribers.load_subscribers" do |app|
        config.to_prepare do
          subscribers = app.root.join("app/subscribers")
          Rails.autoloaders.main.eager_load_dir(subscribers) if subscribers.directory?
        end
      end
    end
  end
end
