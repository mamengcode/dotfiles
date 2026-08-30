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

Other files in `~/.config` are not managed or overwritten. Bootstrap creates a
machine-local `~/.config/chezmoi/chezmoi.toml` pointing at this checkout when it
is absent; that file is intentionally not tracked. `.chezmoiignore` keeps
repository documentation, metadata, and Homebrew bundles out of the
home-directory target when chezmoi applies this repository.

## Bootstrap

From a manually checked-out copy of this repository:

```sh
./bootstrap.sh                 # core CLI/build setup only
./bootstrap.sh --with-optional # also install captured apps and project tools
```

The script installs Homebrew only if it is absent, runs the core `Brewfile`
without cleanup, applies the chezmoi source, and installs the configured mise
runtimes. Optional applications, VS Code extensions, project tools, and npm
packages are isolated in `Brewfile.optional` and require explicit opt-in. It
never runs `gh auth login`, performs service authentication, removes packages,
or migrates npm globals. Modified managed files are not force-overwritten.

`Brewfile` is the portable shared CLI/build baseline. `Brewfile.optional` is a
snapshot of this machine's personal GUI and project-specific state; review it
before using it on another machine. Homebrew's `pkgconf` formula provides the
`pkg-config` command.

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
- Run `chezmoi diff`, `chezmoi status`, and `chezmoi apply` normally after
  bootstrap; the machine-local config points them at this checkout. SSH uses
  chezmoi's `private_` naming so restrictive permissions are preserved.
- If GitHub CLI access is later needed, authenticate separately and manually
  with `gh auth login`; no authentication was attempted by this setup.
- `brew bundle check` should be run with `--no-upgrade` for this setup. The
  optional bundle reflects this machine's current apps and may require review
  before use elsewhere; bootstrap intentionally uses `--no-upgrade`.
