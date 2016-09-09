defmodule MrT.RunStrategy.RootName do
  @moduledoc """
  Strategy to match all files with same `root` (cleaned basename) in filename
  """

  def match(all_files, file) when is_binary(file), do: match(all_files, [file])
  def match(all_files, changed_files) do
    for file <- changed_files do
      match_file(all_files, file)
    end
    |> List.flatten
  end

  def match_file(all_files, file) do
    rootname = name(file)
    all_files |> Enum.filter(fn(f) -> String.contains?(f, rootname) end)
  end

  def name(file) do
    Path.basename(file)
    |> Path.rootname(".exs")
    |> Path.rootname(".ex")
    |> String.replace(~r/_test/, "")
    |> String.replace(~r/_controller/, "")
  end
end
