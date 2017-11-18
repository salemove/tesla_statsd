defmodule Tesla.StatsD.Backend do
  @moduledoc """
  A behaviour for StatsD backend.

  [ExStatsD](https://github.com/CargoSense/ex_statsd) is supported
  out of box.
  """

  @type metric :: String.t()
  @type amount :: integer | float
  @type options :: Keyword.t()

  @doc """
  Record a gauge entry
  """
  @callback gauge(amount, metric, options) :: any

  @doc """
  Record a histogram value
  """
  @callback histogram(amount, metric, options) :: any
end
