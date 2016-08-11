defmodule MrT.Utils do
  alias ExUnit.CaptureIO
  def recompile do
    a = :erlang.timestamp
    compile
    b = :erlang.timestamp
    puts "recompiled in #{timediff(a, b)} secs"
  end

  def compile, do: compile(Mix.Project.umbrella?)
  def compile(false) do
    CaptureIO.capture_io(fn ->
      IEx.Helpers.recompile
    end)
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
    require_file(File.exists?(file), file)
  end
  def require_file(false, file), do: puts "not found file #{file}"
  def require_file(true,  file) do
    puts "require #{file}"
    Code.compiler_options(ignore_module_conflict: true) # prevents "warning: redefining module Foo"
    res = :elixir_compiler.file(file) |> Enum.map(fn({m,_b})-> m end)
    Code.compiler_options(ignore_module_conflict: false)
    res
  end

  @doc """
  small tracing helper, that can be deactivated globally
  """
  def debug(v),         do: debug(is_debug?, v)
  def debug(true, v),   do: IO.inspect(v)
  def debug(false, v),  do: v

  def puts(v),          do: puts(is_debug?, v)
  def puts(true, v),    do: IO.puts v
  def puts(false, v),   do: v

  def is_debug? do
    Application.get_env(:mr_t, :debug, false)
  end

  def verbosity_on(),  do: Application.put_env(:mr_t, :debug, true)
  def verbosity_off(), do: Application.put_env(:mr_t, :debug, false)
end
