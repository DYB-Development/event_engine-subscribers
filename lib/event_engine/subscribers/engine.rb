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

      initializer "event_engine.subscribers.forget_unloaded_subscribers" do |app|
        app.reloader.before_class_unload { Registry.clear! }
      end
    end
  end
end
