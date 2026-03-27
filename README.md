# Dotfiles

macOS dotfiles. Keyboard-centric, minimal, fast.

## Setup

```bash
git clone https://github.com/aristeoibarra/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh --install-deps  # installs deps + creates symlinks
```

Flags: `--dry-run` to preview, `--skip-validation` to bypass checks.

### Yabai SIP

Yabai needs partial SIP disable. Boot into Recovery (hold power on Apple Silicon), then:

```bash
csrutil enable --without debug --without fs
```

After reboot:

```bash
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
yabai --start-service && skhd --start-service
```

## Stack

| Tool | Purpose |
|------|---------|
| nvim | Editor (lazy.nvim, LSP, Telescope) |
| alacritty | Terminal |
| tmux | Multiplexer + session persistence |
| yabai + skhd | Tiling WM + hotkeys |
| zsh | Shell (no OMZ, standalone plugins via brew) |
| starship | Prompt |
| zen | Browser (Betterfox privacy config) |

CLI: bat, rg, fd, eza, sd, delta, difft, fzf, zoxide, lazygit, gh, atuin, yazi, sesh

## Theme

```bash
bin/theme              # interactive picker
bin/theme catppuccin-mocha  # direct switch
```

Syncs colors across nvim, alacritty, tmux, starship, lazygit, delta, and FZF. Add themes by creating a new `.sh` in `themes/`.

## Structure

```
alacritty/     Terminal config + theme
atuin/         Shell history
bin/           Scripts (theme, digiin, bw-unlock, obsidian-daily)
claude/        Claude Code config + hooks
git/           .gitconfig + .gitignore_global
macos/         System scripts (animations, display)
nvim/          Neovim (config/, plugins/, utils/, snippets/)
obsidian/      Appearance + CSS snippets
safari/        Safari guard (auto-close private windows)
sesh/          Session manager
skhd/          Hotkey daemon
starship/      Prompt
themes/        Color definitions
tmux/          Multiplexer config + scripts
yabai/         Window manager
zen/           Zen Browser (user.js, userChrome.css)
zsh/           Shell config
```

## Uninstall

```bash
./uninstall.sh             # remove symlinks
./uninstall.sh --remove-deps  # also remove CLI tools
./restore.sh               # restore from .backup files
```

## License

MIT
