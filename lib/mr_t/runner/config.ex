defmodule MrT.Runner.Config do
  @doc """
  Turn on focused runs on a test tag

  E.g: mark a test / module with :focus tag and call
    iex> MrT.Runner.Config.focus(:focus)
    iex> MrT.Runner.Config.focus([:focus, :this])
  """
  def focus(tag_to_focus) when is_atom(tag_to_focus) do
    focus([tag_to_focus])
  end
  def focus(tags_to_focus) when is_list(tags_to_focus) do
    ExUnit.configure(include: tags_to_focus, exclude: [:test])
  end

  @doc """
  Reset configuration for ExUnit to defaults

  Example:
    iex> MrT.Runner.Config.unfocus
  """
  def unfocus do
    ExUnit.configure(include: [], exclude: [])
  end
end
