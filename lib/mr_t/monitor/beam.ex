defmodule MrT.Monitor.Beam do
  use ExFSWatch, dirs: MrT.Config.beam_dirs

  def callback(:stop) do
    IO.puts "STOP"
  end

  def callback(file_path, events) do
    if is_beam?(file_path) do
      MrT.BeamReloader.handle(file_path, events)
    end
  end

  def is_beam?(file_path) do
    (Path.extname file_path) in [".beam"]
  end
end
