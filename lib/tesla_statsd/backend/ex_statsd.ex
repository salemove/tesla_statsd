defmodule Tesla.StatsD.Backend.ExStatsD do
  @moduledoc """
  [ExStatsD](https://github.com/CargoSense/ex_statsd) backend for `Tesla.StatsD`.
  """

  @behaviour Tesla.StatsD.Backend

  @impl true
  def gauge(metric, amount, options) do
    ExStatsD.gauge(amount, metric, options)
  end

  @impl true
  def histogram(metric, amount, options) do
    ExStatsD.histogram(amount, metric, options)
  end
end
