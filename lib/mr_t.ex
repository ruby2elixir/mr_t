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
    ensure_watchers_run
    IO.write :stderr, "MrT started.\n"
  end

  def start() do
    Application.ensure_all_started(:mr_t)
  end

  def ensure_watchers_run do
    MrT.Monitor.Src.start
    MrT.Monitor.Beam.start
    MrT.Monitor.Test.start
  end

end
