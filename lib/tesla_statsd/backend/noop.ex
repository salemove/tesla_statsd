defmodule Tesla.StatsD.Backend.Noop do
  @moduledoc """
  Backend that doesn't actually record any statistics. This can be useful in
  test environments if you want to disable metrics without actually removing
  the middleware.
  """

  @behaviour Tesla.StatsD.Backend

  @impl true
  def gauge(_metric, _amount, _options) do
  end

  @impl true
  def histogram(_metric, _amount, _options) do
  end
end
