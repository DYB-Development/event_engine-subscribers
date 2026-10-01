EventEngine.configure do |config|
  config.rules_path = ENV.fetch("EVENT_ENGINE_RULES", Rails.root.join("config/event_rules.yml").to_s)
end
