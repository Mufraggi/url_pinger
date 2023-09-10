defmodule Backend.Supervisor do
  @moduledoc false

  use Supervisor

  @registry Horde.Registry
  @supervisor Horde.DynamicSupervisor


  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end
  
end
