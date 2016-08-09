defmodule MrT.Config do
  def beam_dirs do
    beam_dirs(Mix.Project.umbrella?)
    |> List.flatten
  end

  def beam_dirs(false) do
    [Mix.Project.compile_path]
  end

  def beam_dirs(true) do
    for %Mix.Dep{app: app, opts: opts} <- Mix.Dep.Umbrella.loaded do
      config = [
        umbrella?: true,
        app_path: opts[:build]
      ]
      Mix.Project.in_project(app, opts[:path], config, fn _ -> beam_dirs end)
    end
  end

  def src_dirs do
    src_dirs(Mix.Project.umbrella?)
    |> List.flatten
  end

  def src_dirs(false) do
    Mix.Project.config
    |> Dict.take([:elixirc_paths, :erlc_paths, :erlc_include_path])
    |> Dict.values
    |> List.flatten
    |> Enum.map(&Path.join app_source_dir, &1)
    |> Enum.filter(&File.exists?/1)
  end

  def src_dirs(true) do
    for %Mix.Dep{app: app, opts: opts} <- Mix.Dep.Umbrella.loaded do
      Mix.Project.in_project(app, opts[:path], fn _ -> src_dirs end)
    end
  end

  def test_dirs do
    test_dirs(Mix.Project.umbrella?)
    |> List.flatten
  end

  def test_dirs(false) do
    root = Path.dirname(Mix.ProjectStack.peek.file)
    ["#{root}/test"]
    |> Enum.filter(&File.exists?/1)
  end

  def test_dirs(true) do
    for %Mix.Dep{app: app, opts: opts} <- Mix.Dep.Umbrella.loaded do
      Mix.Project.in_project(app, opts[:path], fn _ -> test_dirs end)
    end
  end

  def src_extensions do
    Application.get_env(:exsync, :extensions, [".erl", ".hrl", ".ex"])
  end

  def test_extensions do
    [".exs", ".ex"]
  end

  def application do
    :exsync
  end

  def app_source_dir do
    Path.dirname Mix.ProjectStack.peek.file
  end
end
