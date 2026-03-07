#!/bin/bash
# This script is run by DevPod's dotfiles integration
# It bootstraps the development environment in a new devcontainer

set -euo pipefail

REPO_DIR="${REPO_DIR:-$(pwd)}"

echo "🚀 Bootstrapping development environment..."

# Install chezmoi if not already available
if ! command -v chezmoi >/dev/null 2>&1; then
    echo "📦 Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)"
fi

# Apply dotfiles from the locally cloned repo
echo "✨ Applying dotfiles..."
chezmoi init --apply --source="$REPO_DIR"

# Mise will be installed by chezmoi externals
# Activate mise and install tools
if [ -f "$HOME/.local/bin/mise" ]; then
    echo "🔧 Installing mise tools..."
    eval "$("$HOME/.local/bin/mise" activate bash)"
    mise install
fi

echo "✅ Development environment ready!"
