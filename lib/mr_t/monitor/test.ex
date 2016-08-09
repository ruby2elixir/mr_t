defmodule MrT.Monitor.Test do
  use ExFSWatch, dirs: MrT.Config.test_dirs

  def callback(:stop) do
    IO.puts "STOP"
  end

  def callback(file_path, _events) do
    if (Path.extname file_path) in MrT.Config.test_extensions do
      MrT.EventBus.event_for_tests(file_path)
    end
  end
end
