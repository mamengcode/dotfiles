#!/bin/bash
# Safe, repeatable bootstrap for this macOS workstation.
# This script never authenticates services and never removes packages.
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

# Prefer an existing native Apple Silicon Homebrew installation. Installing
# Homebrew is intentionally limited to an explicit manual invocation of this
# script; it is not performed by shell startup files.
if ! command -v brew >/dev/null 2>&1; then
	if [[ -x /opt/homebrew/bin/brew ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	elif [[ -x /usr/local/bin/brew ]]; then
		eval "$(/usr/local/bin/brew shellenv)"
	else
		echo "Homebrew is not installed; installing it now because bootstrap.sh was run manually."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		if [[ -x /opt/homebrew/bin/brew ]]; then
			eval "$(/opt/homebrew/bin/brew shellenv)"
		elif [[ -x /usr/local/bin/brew ]]; then
			eval "$(/usr/local/bin/brew shellenv)"
		else
			echo "Homebrew installation completed but brew was not found." >&2
			exit 1
		fi
	fi
fi

# brew bundle installs missing entries from the snapshot but does not clean up
# packages that are not listed.
brew bundle --no-upgrade --file="$repo_dir/Brewfile"

if ! command -v chezmoi >/dev/null 2>&1; then
	echo "chezmoi is unavailable after brew bundle." >&2
	exit 1
fi

# Only files represented in the chezmoi source layout are applied. Repository
# metadata and documentation are excluded by .chezmoiignore.
chezmoi --source="$repo_dir" --destination="$HOME" apply --force

# Chezmoi's portable default mode is not sufficient for SSH configuration.
chmod 600 "$HOME/.ssh/config"

echo "Bootstrap complete. No service authentication was performed."
