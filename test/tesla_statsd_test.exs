defmodule Tesla.StatsDTest do
  use ExUnit.Case

  import Mox

  defmodule TestClient do
    use Tesla

    adapter(Tesla.Mock)

    def new(opts \\ []) do
      opts = Keyword.put(opts, :backend, StatsMock)

      Tesla.build_client([
        {Tesla.StatsD, opts}
      ])
    end
  end

  setup :verify_on_exit!

  setup do
    Tesla.Mock.mock(fn env -> struct(env, status: 200, body: "hello") end)
    :ok
  end

  test "sends stats for successful requests" do
    expect(StatsMock, :histogram, fn metric, _elapsed, options ->
      assert metric == "http.request"
      assert "http_host:test-api" in options[:tags]
      assert "http_status:200" in options[:tags]
      assert "http_status_family:2xx" in options[:tags]

      :ok
    end)

    TestClient.new() |> TestClient.get("http://test-api/test")
  end

  test "sends http_status:0 for failed requests" do
    expect(StatsMock, :histogram, fn metric, _elapsed, options ->
      assert metric == "http.request"
      assert "http_host:test-api" in options[:tags]
      assert "http_status:0" in options[:tags]
      assert "http_status_family:0xx" in options[:tags]

      :ok
    end)

    Tesla.Mock.mock(fn env -> {:error, %Tesla.Error{env: env, reason: "connection error"}} end)

    assert {:error, %Tesla.Error{}} = TestClient.new() |> TestClient.get("http://test-api/test")
  end

  test "allows configuring metric name" do
    metric = "foo"

    expect(StatsMock, :histogram, fn ^metric, _elapsed, _options -> :ok end)

    TestClient.new(metric: metric) |> TestClient.get("http://test-api/test")
  end

  test "allows configuring metric name with function" do
    metric = fn env -> env.url end

    expect(StatsMock, :histogram, fn "http://test-api/test", _elapsed, _options -> :ok end)

    TestClient.new(metric: metric) |> TestClient.get("http://test-api/test")
  end

  test "allows configuring tags per request" do
    tags = ["service:test", "env:test"]

    expect(StatsMock, :histogram, fn _metric, _elapsed, options ->
      assert "http_host:test-api" in options[:tags]
      assert "http_status:200" in options[:tags]
      assert "http_status_family:2xx" in options[:tags]
      assert "service:test" in options[:tags]
      assert "env:test" in options[:tags]

      :ok
    end)

    TestClient.new(tags: tags) |> TestClient.get("http://test-api/test")
  end

  test "allows configuring tags per request with function" do
    tags = fn env -> ["url:#{env.url}"] end

    expect(StatsMock, :histogram, fn _metric, _elapsed, options ->
      assert "http_host:test-api" in options[:tags]
      assert "http_status:200" in options[:tags]
      assert "http_status_family:2xx" in options[:tags]
      assert "url:http://test-api/test" in options[:tags]

      :ok
    end)

    TestClient.new(tags: tags) |> TestClient.get("http://test-api/test")
  end

  test "allows configuring submission type" do
    expect(StatsMock, :gauge, fn _metric, _elapsed, options ->
      assert "http_host:test-api" in options[:tags]
      assert "http_status:200" in options[:tags]
      assert "http_status_family:2xx" in options[:tags]

      :ok
    end)

    TestClient.new(metric_type: :gauge) |> TestClient.get("http://test-api/test")
  end
end
