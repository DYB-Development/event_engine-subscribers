require "rails"

module EventEngine
  module Subscribers
    class Engine < ::Rails::Engine
      isolate_namespace EventEngine::Subscribers

      config.event_engine_subscribers = ActiveSupport::OrderedOptions.new
      config.event_engine_subscribers.inline_packs = []

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

      initializer "event_engine.subscribers.check_inline_packs", after: "event_engine.subscribers.register_processor" do |app|
        config.after_initialize do
          packs = app.config.event_engine_subscribers.inline_packs
          Subscribers.check_inline!(Subscribers.routes, packs: packs) if packs.any?
        end
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
