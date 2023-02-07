# Highlight selected text in all windows

With this plugin, when you select text in visual mode, all instances of that text will be
highlighted in all visible windows. This makes it simple and convenient to spot any duplicated text.

https://user-images.githubusercontent.com/62202958/217337259-66199579-c39e-4fd7-b57f-246b546231e2.mp4

## Requirements

[neovim >=0.7.0](https://github.com/neovim/neovim/wiki/Installing-Neovim)

## Install

### [Packer](https://github.com/wbthomason/packer.nvim)

```lua
use 'aaron-p1/match-visual.nvim'
```

## Setup (Optional)

```lua
require('match-visual').setup({
    -- id to use in matchadd(). Only needs to be set if you already use this id
    match_id = 118,
    -- Visual group to use for highlighting
    -- You could also override the "VisualMatch" hl group to change the highlights.
    hl_group = "Visual"
})
```

## Contributing

If you're interested in contributing to this plugin, it's important to note that it's written in
[fennel](https://fennel-lang.org/). The lua code is generated using the fennel transpiler, so all
contributions must also be written in fennel. You can use the command `$ make` to transpile the
code, and before committing any changes, it's mandatory that you use the
[fnlfmt](https://git.sr.ht/~technomancy/fnlfmt) tool by running `$ make format` or using the
[null-ls](https://github.com/jose-elias-alvarez/null-ls.nvim) neovim plugin to format the code.

If you're using [nix](https://github.com/NixOS/nix), a package manager for Linux and other Unix
systems, you can easily install the necessary programs for development by running
`$ nix develop`, or by using [direnv](https://github.com/direnv/direnv) with
[nix-direnv](https://github.com/nix-community/nix-direnv).
