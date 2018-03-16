defmodule MrT.Monitor.Src do
  @moduledoc """
  Watcher/monitor module responsible for `src` files, required recompilation
  """

  use ExFSWatch, dirs: MrT.Config.src_dirs()

  def callback(:stop) do
    IO.puts "STOP"
  end

  def callback(file_path, _events) do
    if (Path.extname file_path) in MrT.Config.src_extensions do
      MrT.Utils.require_file(file_path)
      MrT.Utils.recompile
      MrT.EventBus.event_for_tests(file_path)
    end
  end
end
