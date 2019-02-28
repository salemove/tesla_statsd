defmodule Tesla.StatsD do
  @moduledoc """
  This middleware sends histogram stats to Datadog for every outgoing request.
  The sent value is response time in milliseconds.

  Metric name is configurable and defaults to "http.request".
  The middleware also sends tags:

    * `http_status` - HTTP status code.
    * `http_status_family` (2xx, 4xx, 5xx) - HTTP status family
    * `http_host` - The host request has been sent to

  Tags have "http" in their names to avoid collisions with default tags sent by
  Datadog StatsD agent.

  ## Configuration

    * `:backend` - StatsD backend module. Defaults to `Tesla.StatsD.Backend.ExStatsD`.
      A backend must implement `Tesla.StatsD.Backend` behaviour. `Statix` backends are
      supported by default, just provide a module name that uses `Statix` (`use Statix`).
    * `:metric` - Metric name. Can be ether string or function `(Tesla.Env.t -> String.t)`.
    * `:metric_type` - Metric type. Can be `:histogram` (default) or `:gauge`. See
      [Datadog documentation](https://docs.datadoghq.com/guides/dogstatsd/#data-types).
    * `:tags` - List of additional tags. Can be either list or function `(Tesla.Env.t -> [String.t])`.
    * `:sample_rate` - Limit how often the metric is collected (default: 1)

  ## Usage with Tesla

      defmodule AccountsClient do
        use Tesla

        plug Tesla.StatsD,
          metric: "external.request",
          tags: ["service:accounts"],
          backend: MyApp.Statix
      end
  """

  @behaviour Tesla.Middleware

  @default_options [
    metric: "http.request",
    metric_type: :histogram,
    backend: Tesla.StatsD.Backend.ExStatsD,
    sample_rate: 1,
    tags: []
  ]

  # `reraise` macro in `call/3` expands into `case` statement
  # which triggers warnings "guard test is_binary/is_atom(exception) can never succeed"
  @dialyzer {:no_match, call: 3}

  def call(env, next, opts) do
    opts = opts || []
    start = System.monotonic_time()

    result = Tesla.run(env, next)

    case result do
      {:ok, env} ->
        send_stats(env, elapsed_from(start), opts)

      {:error, _reason} ->
        send_stats(%{env | status: 0}, elapsed_from(start), opts)
    end

    result
  end

  defp send_stats(env, elapsed, opts) do
    opts = Keyword.merge(@default_options, opts)

    backend = Keyword.fetch!(opts, :backend)
    rate = Keyword.fetch!(opts, :sample_rate)
    tags = Keyword.fetch!(opts, :tags)
    metric = opts |> Keyword.fetch!(:metric) |> normalize_metric(env)
    metric_type = Keyword.fetch!(opts, :metric_type)

    apply(backend, metric_type, [
      metric,
      elapsed,
      [sample_rate: rate, tags: build_tags(env, tags)]
    ])
  end

  defp build_tags(env, tags) do
    default_tags(env) ++ custom_tags(tags, env)
  end

  defp default_tags(%{status: status} = env) do
    [
      "http_status:#{status}",
      "http_host:#{extract_host(env)}",
      "http_status_family:#{http_status_family(status)}"
    ]
  end

  defp custom_tags(tags, env) when is_function(tags) do
    tags.(env)
  end

  defp custom_tags(tags, _env) do
    tags
  end

  defp extract_host(%{url: url} = _env) do
    %URI{host: host} = URI.parse(url)
    host
  end

  defp http_status_family(status) do
    "#{div(status, 100)}xx"
  end

  defp elapsed_from(start) do
    System.convert_time_unit(System.monotonic_time() - start, :native, :millisecond)
  end

  defp normalize_metric(metric, env) when is_function(metric) do
    metric.(env)
  end

  defp normalize_metric(metric, _env) do
    metric
  end
end
