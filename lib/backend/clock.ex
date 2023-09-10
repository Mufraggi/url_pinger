defmodule Backend.Clock do
  @moduledoc false

  defstruct id: nil, pingers: nil

  use GenServer

  alias Backend.Events.{Tick}

  #@every 300_000
  @every 30_000
  def name(%__MODULE__{id: id}) do
    "clock-#{id}"
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: args[:via])
  end

  def init(args) do
  Process.send_after(self(), :tick, round(@every))
  {:ok, %{id: args[:id], pingers: args[:pingers]}}
end


  @impl true
  def handle_info(:tick, clock) do
    Enum.each(clock.pingers, fn pid ->
      GenServer.cast(pid, :state)
    end)
    Process.send_after(self(), :tick, round(@every))
    {:noreply, clock }
  end
end
