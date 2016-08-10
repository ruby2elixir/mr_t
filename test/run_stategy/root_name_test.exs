defmodule MrT.RunStrategy.RootName.Test do
  use ExUnit.Case
  doctest MrT.RunStrategy.RootName
  alias MrT.RunStrategy.RootName

  @all_test_files [
    "test/some/file_test.exs",
    "test/some/another_test.exs",
    "test/controllers/user_controller_test.exs",
    "test/controllers/user/update_test.exs",
    "test/models/user_test.exs",
  ]

  test "it matches based file base name" do
    res = RootName.match(@all_test_files, "lib/some/file.ex")
    assert res == ["test/some/file_test.exs"]
  end

  test "it matches also for changes in controllers files" do
    res = RootName.match(@all_test_files, "lib/some/file_controller.ex")
    assert res == ["test/some/file_test.exs"]
  end

  test "it returns all the tests with the common string found" do
    res = RootName.match(@all_test_files, "lib/models/user.ex")
    assert res == ["test/controllers/user_controller_test.exs", "test/controllers/user/update_test.exs", "test/models/user_test.exs"]
  end

  test "it requires the full string to match (no fuzzy matching yet...)" do
    res = RootName.match(["some/fil_test.exs"], ["lib/some/file.ex"])
    assert res == []
  end
end
