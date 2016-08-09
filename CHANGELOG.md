## CHANGELOG


v0.5.5:
-  much less logic for reloading, overall simpler code

v0.5.4:
-  works better with controller tests (the matcher remove _controller from the filename before matching)


v0.5.3:
- turn full recompilation back on (solves https://github.com/ruby2elixir/mr_t/issues/1)
- use the IEx.Helpers recompile function (it seems more robust)
