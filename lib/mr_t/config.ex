defmodule MrT.Config do
  @doc """
  test runner, defaults to Runner.ExUnit
  """
  def test_runner,    do: Application.get_env(:mr_t, :test_runner, MrT.Runner.ExUnit)
  def test_runner(v), do: Application.put_env(:mr_t, :test_runner, v)

  @doc """
  strategy how to filter test files
  """
  def test_runner_strategy,  do: Application.get_env(:mr_t, :test_runner_strategy, MrT.RunStrategy.RootName)
  def test_runner_strategy(:all),       do: Application.put_env(:mr_t, :test_runner_strategy, MrT.RunStrategy.RunAll)
  def test_runner_strategy(:root_name), do: Application.put_env(:mr_t, :test_runner_strategy, MrT.RunStrategy.RootName)
  def test_runner_strategy(v),          do: Application.put_env(:mr_t, :test_runner_strategy, v)

  @doc """
  file extensions to match in src dirs
  """
  def src_extensions do
    Application.get_env(:mr_t, :extensions, [".erl", ".hrl", ".ex"])
  end

  @doc """
  file extensions to match in test dirs
  """
  def test_extensions do
    Application.get_env(:mr_t, :test_extensions, [".exs", ".ex"])
  end

  @doc """
  all possible folders with code files
  """
  def src_dirs do
    src_dirs(Mix.Project.umbrella?)
    |> List.flatten
  end


  defp src_dirs(false) do
    Mix.Project.config
    |> Map.take([:elixirc_paths, :erlc_paths, :erlc_include_path])
    |> Map.values
    |> List.flatten
    |> Enum.map(&Path.join app_source_dir(), &1)
    |> Enum.filter(&File.exists?/1)
  end

  defp src_dirs(true) do
    for %Mix.Dep{app: app, opts: opts} <- Mix.Dep.Umbrella.loaded do
      Mix.Project.in_project(app, opts[:path], fn _ -> src_dirs() end)
    end
  end

  @doc """
  all possible folders with test files
  """
  def test_dirs do
    test_dirs(Mix.Project.umbrella?)
    |> List.flatten
  end

  defp test_dirs(false) do
    root = Path.dirname(Mix.ProjectStack.peek.file)
    ["#{root}/test"]
    |> Enum.filter(&File.exists?/1)
  end

  defp test_dirs(true) do
    for %Mix.Dep{app: app, opts: opts} <- Mix.Dep.Umbrella.loaded do
      Mix.Project.in_project(app, opts[:path], fn _ -> test_dirs() end)
    end
  end

  defp app_source_dir do
    Path.dirname Mix.ProjectStack.peek.file
  end
end
