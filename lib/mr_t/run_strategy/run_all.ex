defmodule MrT.RunStrategy.RunAll do
  def match(all_files, file) when is_binary(file), do: match(all_files, [file])
  def match(all_files, changed_files) do
    all_files
  end
end
