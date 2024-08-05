# Dotfiles

This repository contains customized configurations for the Neovim environments and terminal, including specific plugins and keymaps to enhance development productivity. It makes uses of [LazyVim](https://www.lazyvim.org/) as preconfigured set of plugins to simplify the use of Neovim. Also contains configurations for [Starship](https://starship.rs/) with lovely colors by using Catppuccin palette. Dotfiles are managed with [Chezmoi](https://www.chezmoi.io/). Chezmoi help you to manage your dotfiles across multiples machines and provides features to run scripts to install packages.

## Install

Run command below to install dotfiles and packages with brew

```
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply leoalipazaga
```
