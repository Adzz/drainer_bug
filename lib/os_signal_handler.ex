defmodule OSSignalHandler do
  @moduledoc """
  """
  @behaviour :gen_event
  @table_name :os_signal_tracker
  require Logger

  def init(_) do
    Logger.info("Wiring up OS signal handler")

    case :ets.info(@table_name) do
      :undefined ->
        :ets.new(@table_name, [:set, :named_table, :protected, read_concurrency: true])

      _ ->
        @table_name
    end

    true = :ets.insert(@table_name, {:is_draining?, false})

    {:ok, nil}
  end

  def handle_event(:sigterm, state) do
    Logger.warn("os.signals SIGTERM received")
    true = :ets.insert(@table_name, {:is_draining?, true})
    :erl_signal_handler.handle_event(:sigterm, state)
  end

  # If it's not a sigterm then we let the defaults kick in.
  def handle_event(signal, state) do
    Logger.info("os.signals Signal received: #{signal}")
    :erl_signal_handler.handle_event(signal, state)
  end

  def handle_call(_, state), do: {:ok, :ok, state}

  @doc """
  Returns true if we have been sent a sigterm, false otherwise.
  """
  def draining? do
    [is_draining?: drained] = :ets.lookup(@table_name, :is_draining?)
    drained
  end
end
