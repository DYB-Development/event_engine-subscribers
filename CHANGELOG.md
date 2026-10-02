# Changelog

All notable changes to this gem are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.0] - 2026-10-02

### Added

- `config.event_engine_subscribers.inline_packs`, the event packs whose events must run
  inline. When it names any, the gem runs the inline check at start-up, refusing events
  in those packs routed to `background`. It names none by default.

### Changed

- `check_inline!` takes `packs:`, and refuses only background events in those packs. A
  host no longer calls it from its own start-up code.

## [0.3.0] - 2026-10-02

### Added

- `EventEngine::Subscribers.check_inline!(routes)`, which a host calls once the subscriber
  processors are registered. It runs event_engine's rules check, then raises
  `BackgroundEventsError` naming every event routed to `background`.

## [0.2.0] - 2026-10-01

### Added

- The app refuses to start while an event routed to `inline` or `background` has no
  subscriber, and the error names each such event.

## [0.1.1] - 2026-09-30

### Changed

- The gem ships its Claude Code agents in `the_local/` for the current the_local, and
  no longer ships the file that registered them through the removed `TheLocal.register`.

### Fixed

- Every subscriber in `app/subscribers` is registered when the app starts, so an event
  sent in development runs subscribers that nothing has mentioned yet.
- A subscriber is registered once after a code reload, where it used to be registered
  again beside its old class, so its `#handle` ran twice with the old code and the new.

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
