defmodule MrT.TestHandler do
  use GenEvent

  def handle_event({:test, file}, files) do
    MrT.test_runner.run_matching([file])
    {:ok, [file | files]}
  end

  def handle_event(_, files) do
    {:ok, files}
  end

  def handle_call(:files, files) do
    {:ok, Enum.reverse(files), files}
  end

  def handle_call(:flush, files) do
    {:ok, Enum.reverse(files), []}
  end
end

defmodule MrT.TestHandlerWatcher do
  use GenServer

  @doc """
    starts the GenServer, this should be done by a Supervisor to ensure
    restarts if it itself goes down
  """
  def start_link(event_bus_id) do
    GenServer.start_link(__MODULE__, event_bus_id)
  end

  @doc """
    inits the GenServer by starting a new handler
  """
  def init(event_bus_id) do
    start_handler(event_bus_id)
  end

  @doc """
    handles EXIT messages from the GenEvent handler and restarts it
  """
  def handle_info({:gen_event_EXIT, _handler, _reason}, event_bus_id) do
    {:ok, event_bus_id} = start_handler(event_bus_id)
    {:noreply, event_bus_id}
  end

  defp start_handler(event_bus_id) do
    case GenEvent.add_mon_handler(event_bus_id, MrT.TestHandler, []) do
     :ok ->
       {:ok, event_bus_id}
     {:error, reason}  ->
       {:stop, reason}
    end
  end
end

defmodule MrT.EventBus do
  alias MrT.{TestHandlerWatcher}
  def start do
    {_, _pid} = GenEvent.start_link([name: :event_bus])
    add_handler(Mix.env)
    :ok
  end

  def add_handler(:test) do
    TestHandlerWatcher.start_link(:event_bus)
  end

  def add_handler(_) do
  end

  def event_for_tests(file) do
    GenEvent.notify(:event_bus, {:test, file})
  end
end
