# MrT

[![Build status](https://travis-ci.org/ruby2elixir/mr_t.svg "Build status")](https://travis-ci.org/ruby2elixir/mr_t)
[![Hex version](https://img.shields.io/hexpm/v/mr_t.svg "Hex version")](https://hex.pm/packages/mr_t)
![Hex downloads](https://img.shields.io/hexpm/dt/mr_t.svg "Hex downloads")


<img src="https://raw.githubusercontent.com/ruby2elixir/mr_t/master/docs/mr-t.jpg" alt="alt text" height="200">

Instant code-reloader and test runner for Elixir in one package.
Currently tightly coupled to ExUnit and the conventional folder structure of Elixir packages.

## Installation
  1. Add `mr_t` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:mr_t, "~> 0.5.0", only: [:test, :dev]}]
    end
    ```

### Alternatives:
  - [ExSync](https://github.com/falood/exsync/)
  - [mix test.watch](https://github.com/lpil/mix-test.watch/)
  - [EyeDrops](https://github.com/rkotze/eye_drops)

### Desktop Notifications
  - [ex_unit_notifier - Desktop notifications for ExUnit](https://github.com/navinpeiris/ex_unit_notifier) (recommended)
  - [mix_test_notify - OSX notifications for mix test](https://github.com/apdunston/mix_test_notify)

### Why pick this library instead of other alternatives?

Well... Because of the cool name, of course!

> People ask me what the "T" stands for in my name. If you're a man, the "T" stands for TESTING. If you're a woman or child, it also stands for TESTING!
>
>> <cite>Mr. T</cite>

Back to serious...

In development mode this library allows you to iterate really quickly on your code, in similar fashion like the the Clojure REPL does. You can type in the editor and see the effect directly in IEx, without explicit "recompile" call. That feels a bit like magic... Good magic! On syntax errors you'll get the backtrace, but besides the library stays out of your way. And you have to start it explictly, just in case you don't want magic code reloading in the IEx.

In test mode it executes test code directly in current IEx, so you dont have to run a separate Mix process in the background. That keeps the feedback loop really tight, especially for large projects.

Skip loading all the code / tests again and again for every test run, you will feel the difference quite quickly. Also I'd like to have a concept of `RunStrategies`, that is a flexible way to match a changed file to corresponding test files.

Right now there is only a very simple RootName strategy, that turns a file like "lib/logic/email_sender.ex" to "email_sender" and runs all test files with that string in the full paths, like:

    - tests/email_sender_test.exs
    - tests/email_sender/mandrill_adapter_test.exs

This simple strategy allows you to run just the relevant tests quickly on each save-file stroke, directly in the IEx. It works also with Phoenix controllers / models quite nicely. Because we're keeping the Erlang VM running, the feedback for our TDD cycle is exceptionally fast.

### Demo: MrT Dev mode
<img src="https://raw.githubusercontent.com/ruby2elixir/mr_t/master/docs/mrt_dev_mode.gif" alt="Demo" height="300">

- Installation
- Starting MrT
- Code reloading in dev mode
- Feedback on syntax errors
- Reloading continues to work after syntax errors fixed

<br />
<br />
<br />

### Demo: MrT Test mode
<img src="https://raw.githubusercontent.com/ruby2elixir/mr_t/master/docs/mrt_test_mode.gif" alt="Demo" height="300">

- TDD cycle
- Starting MrT
- Code reloading in test mode
- Changes to code without matching tests files
- Changes to code where only the relevant tests files are executed

<br />
<br />
<br />


## Code Reloader
    $ iex -S mix
    # this starts only the code reloading, because we are in the :dev environment
    iex> MrT.start
    # now write some code in the editor, it will be immediately available in the IEx console


## Testrunner
    $ MIX_ENV=test iex -S mix
    # this starts test runner and  code reloading, because we are in the :test environment
    iex> MrT.start
    # now code / write unit tests

    ## for more manual control:
    # run tests only with "user" in filename
    iex> MrT.run_matching("user")
    # run all tests
    iex> MrT.run_all


### Stopping
    iex> MrT.stop

### Automatic loading
    # dev mode
    $ iex -S mix mr_t

    # test mode
    $ MIX_ENV=test iex -S mix mr_t

### TODO
    [x] remove most of the reloading logic, because now the recompilation happens with IEx.Helpers
    [x] allow stopping MrT
    [x] make configuration more flexible
    [x] configurable verbosity (default is silent)
    [ ] Add MrT.Doctor for self-diagnosis
    [ ] handle fs events properly (deletion / tmp files)
    [ ] allow multiple ordered run_strategies
    [ ] write unit tests

