defmodule MrT do
  alias MrT.Config
  alias MrT.Runner.Config, as: RunnerConfig
  def start do
    Application.ensure_all_started(:mr_t)
  end

  def stop do
    Application.stop(:exfswatch)
    Application.stop(:mr_t)
    MrT.Quotes.bye
  end

  defdelegate run_all,             to: Config.test_runner
  defdelegate run_matching(files), to: Config.test_runner

  defdelegate focus(f),            to: RunnerConfig
  defdelegate reset,               to: RunnerConfig

  @doc """
  Convenience functions to turn on/off all tests strategy

  Example:
    iexd> MrT.run_all_strategy_on
    iexd> MrT.run_all_strategy_off
  """

  def run_all_strategy_on,  do: Config.test_runner_strategy(:all)
  def run_all_strategy_off, do: Config.test_runner_strategy(:root_name)

  def start(_, _) do
    cond do
      Mix.env in [:dev, :test] -> _start()
      true                     -> IO.write :stderr, "MrT NOT stared. Only :dev, :test environments are supported.\n"
    end
    {:ok, self}
  end

  def _start do
    ensure_event_bus_running
    ensure_watchers_running
    MrT.Quotes.quote_of_day
  end

  defp watchers(:dev) do
    [MrT.Monitor.Src]
  end

  defp watchers(:test) do
    watchers(:dev) ++ [MrT.Monitor.Test]
  end

  defp ensure_watchers_running do
    watchers(Mix.env) |> Enum.each(fn(m)-> m.start end)
  end

  defp ensure_event_bus_running do
    MrT.EventBus.start
  end
end
