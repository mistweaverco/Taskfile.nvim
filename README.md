Taskfile.nvim
=============

A Vim/Neovim plugin to run [Taskfile][Taskfile] tasks.

You need to have `Taskfile` in the current working directory of Vim/Neovim.

## Usage

You can run the `build` task of the Taskfile like so:

`:Taskfile build` or `:call Taskfile#Run("build")`

### Cache

The Tasks of the Taskfile are cached, if you modify the Taskfile and add jobs,
you need to reload the Taskfile like so:

```
:call Taskfile#Reload()<CR>
```

[Taskfile]: https://git.superevilmegaco.com/bash/Taskfile

