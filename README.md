# MrT
<img src="https://raw.githubusercontent.com/ruby2elixir/mr_t/master/docs/mr-t.jpg" alt="alt text" height="200">

Instant code-reloader and test runner for Elixir in one package.
Currently tightly coupled to ExUnit and the conventional folder structure of Elixir packages.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `mr_t` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:mr_t, "~> 0.1.0", only: [:test, :dev]}]
    end
    ```

## Code Reloader
    $ iex -s mix
    # this starts only the code reloading, because we are in the :dev environment
    iex> MrT.start
    # now write some code in the editor, it will be immediately available in the IEx console


## Testrunner
    $ MIX_ENV=test iex -s mix
    # this starts test runner and  code reloading, because we are in the :test environment
    iex> MrT.start
    # now code / write unit tests

    ## for more manual control:
    # run tests only with "user" in filename
    iex> MrT.test_runner.run_matching(["user"])
    # run all tests
    iex> MrT.test_runner.run_all


### Inspired by:
  - [ExSync](https://github.com/falood/exsync/)
  - [mix test.watch](https://github.com/lpil/mix-test.watch/)

### TODO
    [ ] make configuration more flexible
    [ ] handle file deletion in Monitor.Src
    [ ] write unit tests
    [ ] make compatible with Phoenix/complex projects (?)

