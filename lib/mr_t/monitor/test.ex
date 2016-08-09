defmodule MrT.Monitor.Test do
  use ExFSWatch, dirs: MrT.Config.test_dirs

  def callback(:stop) do
    IO.puts "STOP"
  end

  def callback(file_path, _events) do
    if (Path.extname file_path) in MrT.Config.test_extensions do
      MrT.TestRunner.run_matching([file_path])
    end
  end
end
