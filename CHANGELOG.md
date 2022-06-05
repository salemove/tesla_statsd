# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Add `Noop` backend

## [0.3.1]

### Added
- Support for Elixir 1.8+

## [0.3.0]

### Changed
- `Tesla.StatsD.Backend` callback functions changed signature. Both `gauge/3` and `histogram/3`
  now accept metric name as a first argument and metric value as a second (previously it was
  the other way around).
- Default backend changed to `Tesla.StatsD.Backend.ExStatsD`.

### Added
- `Tesla.StatsD.Backend.ExStatsD` backend to support `ExStatsD`.

## [0.2.0]

### Added
- Support for Tesla 1.1.

### Removed
- Support for Tesla 0.x.

## [0.1.2]

### Added
- Support for Elixir 1.8+

## [0.1.1]

### Changed
- Elixir minimum version set to 1.4.

## [0.1.0]

Initial release

[0.3.1]: https://github.com/salemove/tesla_statsd/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/salemove/tesla_statsd/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/salemove/tesla_statsd/compare/v0.1.2...v0.2.0
[0.1.2]: https://github.com/salemove/tesla_statsd/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/salemove/tesla_statsd/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/salemove/tesla_statsd/tree/v0.1.0
