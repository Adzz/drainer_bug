defmodule DrainerBug.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # This wires up the handler, erlang calls :init on OSSignalHandler for us.
    :ok =
      :gen_event.swap_handler(
        :erl_signal_server,
        {:erl_signal_handler, []},
        {OSSignalHandler, []}
      )

    children = [
      # Start the Telemetry supervisor
      DrainerBugWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: DrainerBug.PubSub},
      # Start the Endpoint (http/https)
      DrainerBugWeb.Endpoint
      # Start a worker by calling: DrainerBug.Worker.start_link(arg)
      # {DrainerBug.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DrainerBug.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DrainerBugWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
