defmodule MrT.Utils do
  def recompile do
    a = :erlang.timestamp
    compile
    b = :erlang.timestamp
    IO.puts "recompiled in #{timediff(a, b)} secs"
  end

  def compile, do: compile(Mix.Project.umbrella?)
  def compile(false) do
    IEx.Helpers.recompile
  end

  def compile(true) do
    for %Mix.Dep{app: app, opts: opts} <- Mix.Dep.Umbrella.loaded do
      Mix.Project.in_project(app, opts[:path], fn _ -> compile end)
    end
  end

  def timediff(a, b), do: :timer.now_diff(b, a) / 1000 / 1000 # in secs

  @doc """
  compiles the module in memory on loading, for quicker turnaround
  """
  def require_file(file) do
    Code.compiler_options(ignore_module_conflict: true) # prevents "warning: redefining module Foo"
    res = :elixir_compiler.file(file) |> Enum.map(fn({m,_b})-> m end)
    Code.compiler_options(ignore_module_conflict: false)
    res
  end

  @doc """
  small tracing helper, that can be deactivated globally
  """
  def debug(v) do
    case is_debug? do
      true -> IO.inspect(v)
      _    -> v
    end
  end

  def is_debug? do
    Application.get_env(:mr_t, :debug, false)
  end
end
