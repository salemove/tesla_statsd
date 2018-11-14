defmodule Tesla.StatsD.Backend do
  @moduledoc """
  A behaviour for StatsD backend.

  [Statix](https://github.com/lexmag/statix) is supported out of box.
  """

  @type metric :: String.t()
  @type amount :: integer | float
  @type options :: Keyword.t()

  @doc """
  Record a gauge entry
  """
  @callback gauge(metric, amount, options) :: any

  @doc """
  Record a histogram value
  """
  @callback histogram(metric, amount, options) :: any
end
