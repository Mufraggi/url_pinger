import HTTPoison.Base
import Poison

defmodule Backend.Pinger do
  @moduledoc false

  defstruct [:consumer, :url]

  use GenServer, restart: :permanent

  def start_link(url) do
    GenServer.start_link(__MODULE__, url, name: {__MODULE__, url})
  end

  @impl true
  def init(url) do
    {:ok, url}
  end

  @impl true
  def handle_cast(:state, state) do
    tmp = Pinger.run()
    IO.puts(tmp)

    {:noreply, state}
  end

  def ping(url) do
    HTTPoison.get(url)
  end

  def checkCallHttp({:ok, response}) do
    {response.status_code, response.body}
  end

  def checkCallHttp({_, _}) do
    IO.puts("La requête a échoué avec le code ")
  end

  def checkResponseStatus({200, body}) do
    Poison.decode(body)
  end

  def checkResponseStatus({status_code, _}) when status_code != 200 do
    IO.puts("La requête a échoué avec le code #{status_code}")
  end

  def checkBody({:ok, decoded_data}) do
    IO.puts("#{inspect(decoded_data)} ")
    :ok
  end

  def checkBody({_, _}) do
    IO.puts("erreur body")
    :error
  end

  def run() do
    ping("https://back.decathlon.invyo.io/api/health")
    |> checkCallHttp
    |> checkResponseStatus
    |> checkBody
  end
end
