defmodule MrT.Utils.Test do
  use ExUnit.Case
  doctest MrT.Utils
  alias MrT.Utils
  import ExUnit.CaptureIO

  describe "require_file" do
    test "does not blow up on tmp files" do
      Utils.verbosity_on
      assert capture_io(fn->
        Utils.require_file("i_dont_exist.ex")
      end) == "not found file i_dont_exist.ex\n"
      Utils.verbosity_off
    end
  end
end
