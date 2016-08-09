defmodule MrT do
  def start(_, _) do
    case Mix.env do
      :dev  -> doit()
      :test -> doit()
      _     -> IO.write :stderr, "MrT NOT stared. Only :dev, :test environments are supported.\n"
    end
    {:ok, self}
  end

  def doit() do
    ensure_event_bus_run
    ensure_watchers_run
    IO.write :stderr, "MrT started.\n"
  end

  def start() do
    Application.ensure_all_started(:mr_t)
  end

  def ensure_watchers_run do
    watchers(Mix.env) |> Enum.each(fn(m)-> m.start end)
  end

  def ensure_event_bus_run do
    MrT.EventBus.start
  end

  def test_runner do
    MrT.Runner.ExUnit
  end

  def test_runner_strategy do
    MrT.RunStrategy.RootName
  end

  def watchers(:dev) do
    [MrT.Monitor.Src, MrT.Monitor.Beam]
  end

  def watchers(:test) do
    watchers(:dev) ++ [MrT.Monitor.Test]
  end
end
