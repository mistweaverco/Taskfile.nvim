Taskfile.nvim
=============

A Vim/Neovim plugin to run [Taskfile][Taskfile] tasks.

You need to have `Taskfile` in the current working directory of Vim/Neovim.

## Usage

You can run the `build` task of the Taskfile like so:

`:Taskfile build` or `:call Taskfile#Run("build")`

You can also autocomplete tasks pressing `<tab>`, or `<tab><tab>`.

### Asynchronous

Taskfile tasks are run synchronous by default.
You can set `g:TaskfileAsynchronous=1` in your `nvim/init.vim`/`.vimrc`
to enable asynchronous mode.

[Taskfile]: https://git.superevilmegaco.com/bash/Taskfile

