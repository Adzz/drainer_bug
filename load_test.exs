defmodule LoadTester do
  require Logger

  def test(batch_size, sleep) do
    Enum.each(0..batch_size, fn _proto ->
      spawn(fn ->
        resp =
          HTTPoison.get("http://localhost:4000", [],
            timeout: 10_000_000,
            recv_timeout: 10_000_000
          )

        Logger.info("Response: #{inspect(resp)}")
      end)
    end)

    Process.sleep(sleep)
    test(batch_size, sleep)
  end
end

LoadTester.test(10, 1000)
