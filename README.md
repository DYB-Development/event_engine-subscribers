# EventEngine::Subscribers

The **subscriber layer** of the [EventEngine](https://github.com/DYB-Development) pipeline.

EventEngine is a schema-first event pipeline. Events are declared with
[`event_engine-event_definition`](https://github.com/DYB-Development/event_engine-event_definition),
compiled into a committed catalog, and emitted through the
[`event_engine`](https://github.com/DYB-Development/event_engine) runtime. The runtime
resolves each event to a **processor** by name, using the host's rules file.

This gem is one of those processors. It runs the subscribers you write in your app —
either synchronously or in a background job.

## Installation

```ruby
gem "event_engine-subscribers"
```

It registers itself at boot as the `:inline` and `:background` processors. **You write
no wiring.**

## Usage

### 1. Write a subscriber

Subclass `Base`, declare the event, implement `#handle`. Declaring the subscription
self-registers the class, so there is nothing else to wire.

```ruby
class SendWelcomeEmail < EventEngine::Subscribers::Base
  subscribes_to :lead_created

  def handle(event)
    UserMailer.welcome(event.payload[:email]).deliver_later
  end
end
```

`event` is the `EventEngine::Event` the runtime built — `event_name`, `payload`,
`metadata`, `occurred_at` and the rest of the envelope.

Several subscribers may subscribe to the same event; each one's `#handle` is called.

### 2. Route the event to this gem

In your app's `config/event_rules.yml`, name `inline` or `background` for the event:

```yaml
events:
  lead_created: inline        # run subscribers synchronously, during emit
  lead_converted: background  # enqueue a job and return immediately
```

That is the whole configuration.

| rule | what happens |
|---|---|
| `inline` | every subscriber for the event runs synchronously inside `emit` |
| `background` | `DispatchSubscribersJob` is enqueued; subscribers run in a worker |

Choose `background` when the work is slow or failure-tolerant, `inline` when the
caller depends on it having happened.

### 3. Emit

```ruby
MarketingEvents.lead_created(lead: lead)
```

Nothing else is needed — the runtime resolves the rule, finds this gem's processor,
and your subscribers run.

## Background dispatch

`background` enqueues `DispatchSubscribersJob` through Active Job, so it uses whatever
queue adapter your app has configured. The event is serialised to a hash and rebuilt
in the worker, so a subscriber receives the same `EventEngine::Event` either way.

Payloads become job arguments, so keep them serialisable — which they already are if
they came from a compiled catalog.

## When nothing runs

If a rule names `inline` or `background` and this gem is not installed, the runtime
raises rather than dropping the event:

```
EventEngine::UnregisteredProcessorError: the rule for event :lead_created
  (pack :marketing) names processor :inline, but no processor is registered
  under that name
```

If subscribers do not run for an event that *is* routed here, check that the
subscriber class has been loaded — `subscribes_to` registers at load time, so a class
Rails has not autoloaded yet has not registered.

## A working example app

[**DYB-Development/event_engine_example**](https://github.com/DYB-Development/event_engine_example)
is a minimal Rails app using this gem — two subscribers on one event to show fan-out,
one routed `inline` and one `background`, with an integration test covering both.

## Development

```bash
bin/setup
bundle exec rake test
```

The suite runs against `test/dummy`. If a sibling `../event_engine` checkout exists it
is used automatically; otherwise the GitHub source is.

## License

Available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
