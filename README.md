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
    -- minimum length of text to match
    min_length = 1,
    -- Visual group to use for highlighting
    -- You could also override the "VisualMatch" hl group manually to change the highlights.
    hl_group = "Visual"
})
```
