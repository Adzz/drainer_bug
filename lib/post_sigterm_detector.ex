defmodule PostSigtermRequestDetector do
  @moduledoc """
  """

  require Logger
  @behaviour Plug

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn, _opts) do
    if OSSignalHandler.draining?() do
      Logger.error(
        "duffel.web.request.draining ERROR! We got a request AFTER a sigterm was called!"
      )

      conn
    else
      conn
    end
  end
end
