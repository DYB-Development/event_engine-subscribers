EventEngine.configure do |config|
  config.rules_path = ENV.fetch("EVENT_ENGINE_RULES", Rails.root.join("config/event_rules.yml").to_s)
end

Rails.application.config.after_initialize do
  EventEngine.register_processor(:durable, ->(event) { event })
end
