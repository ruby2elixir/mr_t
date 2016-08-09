defmodule MrT.TestRunner do
  def run_matching(_files) do
    all_test_files |> doit
  end

  def run(test_files) do
    restart_ex_unit
    task = Task.async(ExUnit, :run, [])
    try do
      require_run_cleanup(task, test_files)
    after
      if Process.alive?(task.pid) do
        Task.shutdown(task)
      end
    end
  end

  def require_run_cleanup(task, test_files) do
    IO.puts "running tests..."
    modules = test_files |> Enum.map(&require_file/1) |> List.flatten
    ### Kernel.ParallelRequire.files is problematic due to race conditions on syntax errors...
    # modules = test_files |> Kernel.ParallelRequire.files([each_module: fn(x,y,z)-> IO.inspect({x, y ,z}) end ])
    ExUnit.Server.cases_loaded()
    %{failures: _failures} = results = Task.await(task, :infinity)
    modules |> delete_modules
    {:ok, results}
  end

  def require_file(file) do
    :elixir_compiler.file(file) |> Enum.map(fn({m,b})-> m end)
  end

  def restart_ex_unit do
    Application.stop(:ex_unit)
    Application.ensure_all_started(:ex_unit)
  end

  def unload(files) do
    files
    |> Enum.map(&Path.expand/1)
    |> Code.unload_files
  end

  def delete_modules(modules) do
    modules |> Enum.map(&delete_module/1)
  end

  def delete_module(m) do
    m |> :code.purge
    m |> :code.delete
  end

  def doit(files) do
    try do
      files
      |> run
    after
      files
      |> unload
    end
  end

  def all_test_files do
    all_test_files(Mix.Project.umbrella?)
  end

  def all_test_files(false) do
    Path.wildcard("test/**/*_test.exs")
  end

  def all_test_files(true) do
    Path.wildcard("apps/**/test/**/*_test.exs")
  end
end
