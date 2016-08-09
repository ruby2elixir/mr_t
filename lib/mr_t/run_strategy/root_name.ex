defmodule MrT.RunStrategy.RootName do
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
  end
end
