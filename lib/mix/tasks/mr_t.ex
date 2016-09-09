defmodule Mix.Tasks.MrT do
  use Mix.Task

  def run(_) do
    unless System.get_env("MIX_ENV") do
      Mix.env(:test)
    end
    Application.ensure_all_started(:mr_t)
    no_halt_unless_in_repl()
  end


  defp no_halt_unless_in_repl do
    unless Code.ensure_loaded?(IEx) && IEx.started? do
      :timer.sleep :infinity
    end
  end
end
