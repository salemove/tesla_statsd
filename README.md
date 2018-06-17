# Tesla.StatsD

`Tesla.StatsD` is an instrumenting middleware for [tesla](https://github.com/teamon/tesla)
HTTP client that submits metrics to StatsD (includes support for Datadog tags).

Documentation can be found at [https://hexdocs.pm/tesla_statsd](https://hexdocs.pm/tesla_statsd).

## Description

This middleware sends histogram or gauge stats to Datadog for every HTTP request.
The sent value is response time in milliseconds.

Metric name is configurable and defaults to "http.request".
The middleware also sends tags:

  * `http_status` - HTTP status code.
  * `http_status_family` (2xx, 4xx, 5xx) - HTTP status family
  * `http_host` - The host request has been sent to

Tags have "http" in their names to avoid collisions with default tags sent by
Datadog StatsD agent.

## Installation

The package can be installed by adding `tesla_statsd` to your list of dependencies in `mix.exs`:

### Tesla 1.x

```elixir
def deps do
  [
    {:tesla_statsd, "~> 0.2.0"}
  ]
end
```

### Tesla 0.9

```elixir
def deps do
  [
    {:tesla_statsd, "~> 0.1.0"}
  ]
end
```

## Configuration

  * `:backend` - StatsD backend module. Defaults to `ExStatsD`. A backend must implement `Tesla.StatsD.Backend` behaviour.
  * `:metric` - Metric name. Can be ether string or function `(Tesla.Env.t -> String.t)`.
  * `:metric_type` - Metric type. Can be `:histogram` (default) or `:gauge`. See
    [Datadog documentation](https://docs.datadoghq.com/guides/dogstatsd/#data-types).
  * `:tags` - List of additional tags. Can be either list or function `(Tesla.Env.t -> [String.t])`.
  * `:sample_rate` - Limit how often the metric is collected (default: 1)

## Usage with Tesla

```elixir
defmodule AccountsClient do
  use Tesla

  plug Tesla.StatsD, metric: "external.request", tags: ["service:accounts"]
end
```

## License

MIT License, Copyright (c) 2017 SaleMove
