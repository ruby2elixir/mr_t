defmodule MrT.Monitor.Src do
  use ExFSWatch, dirs: MrT.Config.src_dirs

  def callback(:stop) do
    IO.puts "STOP"
  end

  def callback(file_path, events) do
    if (Path.extname file_path) in MrT.Config.src_extensions do
      optimistic_require(file_path, events)
    end
  end

  @doc """
  - load the file directly for quicker feedback
  - triggers tests that might match that file
  - for proper handling trigger recompiling and let the beam monitor do the eventual unloading of modules(on deletion)
  """
  def optimistic_require(file_path, events) do
    require_file(file_path)
    MrT.TestRunner.run_matching([file_path])
    MrT.Utils.recompile
  end

  def require_file(file) do
    :elixir_compiler.file(file) |> Enum.map(fn({m,b})-> m end)
  end
end
