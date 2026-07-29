# Changelog

All notable changes to this gem are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-07-29

First published release of `event_engine-subscribers`, the subscriber layer of the
EventEngine pipeline.

### Added

- `EventEngine::Subscribers::Base` — subclass it, declare `subscribes_to :event_name`
  and implement `#handle(event)`. Declaring the subscription self-registers the class.
- `Processor` — registers itself with the `event_engine` runtime as the `:inline` and
  `:background` processors. An event routed to `inline` runs its subscribers
  synchronously; `background` enqueues `DispatchSubscribersJob` and runs them in a
  worker.
- `Registry` — maps event names to their subscriber classes.

### Notes

- Requires `event_engine >= 0.2.0`, which introduced the processor registry.
- Subscribers register when their class is loaded. Under eager loading every
  subscriber in `app/` registers at boot; with lazy loading a subscriber that nothing
  has referenced yet will not have registered.
