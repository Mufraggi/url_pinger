defmodule Backend.Consumer do
  @moduledoc false

  defstruct [:id, :urls]
  use DynamicSupervisor

  alias Backend.{Pinger, Clock, Consumer}

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: args[:name])
  end

  @impl true
  def init(_args) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      restart: :temporary,
      max_restarts: 30_000
    )
  end
end
