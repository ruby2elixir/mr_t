defmodule MrT.BeamReloader do
  def handle(file_path, events) do
    case matrix(file_path, events) do
      {_, _, true, true} ->   # update
        IO.puts "reloading module #{modulename(file_path)}"
        MrT.Utils.reload file_path
      {true, true, _, false} -> # temp file
        nil
      {_, true, _, false} ->  # remove
        IO.puts "unloading module #{modulename(file_path)}"
        MrT.Utils.unload file_path
      _ ->                    # create
        nil
    end
  end

  def modulename(file_path) do
    Path.basename(file_path, ".beam")
  end

  def matrix(file_path, events) do
    {
      :created  in events,
      :removed  in events,
      :modified in events,
      file_path |> File.exists?,
    }
  end
end
