Taskfile.nvim
=============

A Vim/Neovim plugin to run [Taskfile][Taskfile] tasks.

You need to have `Taskfile` in the current working directory of Vim/Neovim.

## Usage

You can run the `build` task of the Taskfile like so:

`:Taskfile build` or `:call Taskfile#Run("build")`

You can also autocomplete tasks pressing `<tab>`, or `<tab><tab>`.

### Verbose

If you like to see the output of the tasks, you can set the plugin to be more
verbose with `TaskVerbose 1`. This will spawn a term for every task executed.

If you want to disable the verbosity again, simply run `TaskVerbose 0`.

[Taskfile]: https://git.superevilmegaco.com/bash/Taskfile

