defmodule MrT.Runner.ExUnit do
  alias ExUnit.CaptureIO
  def strategy,  do: MrT.Config.test_runner_strategy

  def run_all do
    run_matching([""])
  end

  def run_matching(file) when is_binary(file) do
    run_matching([file])
  end

  def run_matching(files) do
    strategy.match(all_test_files, files)
    |> MrT.Utils.debug
    |> doit
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
    require_test_helper
    load_modules(test_files)
    ExUnit.Server.cases_loaded()
    %{failures: _failures} = results = Task.await(task, :infinity)
    {:ok, results}
  end

  def load_modules(test_files) do
    test_files |> Enum.map(&MrT.Utils.require_file/1) |> List.flatten
  end

  def restart_ex_unit do
    CaptureIO.capture_io(fn->
      Application.stop(:ex_unit)
      Application.ensure_all_started(:ex_unit)
    end)
  end

  def unload(files) do
    files
    |> Enum.map(&Path.expand/1)
    |> Code.unload_files
  end

  def doit(files) do
    try do
      files |> run
    after
      files |> unload
    end
  end

  def require_test_helper do
    "test/test_helper.exs" |> MrT.Utils.require_file
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
