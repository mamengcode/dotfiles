# macOS software-engineering workstation

This repository is a small, non-authenticated workstation setup for Apple
Silicon macOS. It is intentionally limited to shell, prompt, Git, SSH host configuration,
tmux, mise defaults, and a Homebrew state snapshot. It does **not**
contain private keys, credentials, shell history, logs, or unrelated
`~/.config` directories.

## Managed files

- `dot_zprofile` → `~/.zprofile`: native `/opt/homebrew` PATH and zsh completions.
- `dot_zshrc` → `~/.zshrc`: cached completion, history, fzf, zoxide, Starship,
  Atuin, mise, direnv, aliases, and optional Homebrew zsh plugins.
- `dot_gitconfig` → `~/.gitconfig`: editor, Delta, safe Git defaults, and an
  include for the untracked `~/.gitconfig.local` identity file.
- `dot_gitconfig.local.example` → `~/.gitconfig.local.example`: placeholder
  identity and work/personal include examples; copy and edit it manually.
- `private_dot_ssh/private_config` → `~/.ssh/config`: the `private_` prefixes
  preserve restrictive 0700/0600 permissions; GitHub uses the existing
  `~/.ssh/id_ed25519`, and the key itself is not tracked.
- `dot_tmux.conf` → `~/.tmux.conf`: conservative mouse, history, and indexing
  defaults.
- `dot_config/starship.toml` → `~/.config/starship.toml`.
- `dot_config/mise/config.toml` → `~/.config/mise/config.toml`, with global
  `node = "lts"` and `python = "3.13"` defaults.

Other files in `~/.config` are not managed or overwritten. `.chezmoiignore`
keeps repository documentation, metadata, and the Homebrew snapshot out of the
home-directory target when chezmoi applies this repository.

## Bootstrap

From a manually checked-out copy of this repository:

```sh
./bootstrap.sh
```

The script installs Homebrew only if it is absent, runs `brew bundle` without
cleanup, and applies the chezmoi source. It never runs `gh auth login`, performs
service authentication, removes packages, or migrates npm globals.

`Brewfile` is an installed-state snapshot generated after setup. It includes
existing formulae, casks, taps, VS Code extensions, and npm package names so a
future `brew bundle` can reproduce that state; it is not a request to remove
anything missing from another machine. Homebrew's `pkgconf` formula provides
the `pkg-config` command.

## Safe setup notes

- Existing settings in `~/.gitconfig` were preserved in the managed baseline.
  Safe defaults are configured: `init.defaultBranch=main`,
  `pull.rebase=true`, `fetch.prune=true`, and `push.autoSetupRemote=true`.
  `user.name` and `user.email` remain unset until you create
  `~/.gitconfig.local`.
- The pre-change `.zshrc` and `.gitconfig` are in
  `~/setup-backups/20260830-000503`. No SSH private-key contents were copied.
- Homebrew Node/Python remain installed. `mise install` installed the configured
  Node LTS and Python 3.13 versions under mise's own data directory; existing
  Homebrew npm globals were not migrated or removed. A project can use a local
  mise configuration when it needs a different runtime.
- If GitHub CLI access is later needed, authenticate separately and manually
  with `gh auth login`; no authentication was attempted by this setup.
- `brew bundle check` may report the installed `node` formula and `codex` cask
  as needing updates because the snapshot reflects the current machine. They
  were intentionally not upgraded; `bootstrap.sh` uses `--no-upgrade`.
