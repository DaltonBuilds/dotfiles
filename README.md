# dotfiles

Personal dotfiles managed with [chezmoi](https://chezmoi.io) — covers shell configuration, terminal, and tooling for both Linux and macOS.

## What's Managed

| File/Directory | Purpose |
|---|---|
| `.bashrc` | Bash config — PATH, Starship prompt, mise activation |
| `.zshrc` | Zsh config — PATH, mise, NVM, gcloud SDK, KUBECONFIG |
| `.vimrc` | Vim configuration |
| `.config/starship.toml` | Starship prompt theme/layout |
| `.config/ghostty/config` | Ghostty terminal settings (Catppuccin Mocha) |
| `.config/mise/config.toml` | mise tool version declarations |

## Tools Managed via mise

[mise](https://mise.jdx.dev) handles tool version management. The following tools are declared in `dot_config/mise/config.toml` and installed automatically on apply:

- `starship` — cross-shell prompt
- `ripgrep` — fast file search
- `bat` — better `cat`
- `helm` — Kubernetes package manager
- `cilium-cli` — Cilium cluster management
- `cosign` — container image signing
- `gcloud` — Google Cloud SDK
- `awscli` — AWS CLI
- `cloudflared` — Cloudflare Tunnel client

mise itself is bootstrapped via a chezmoi external (`~/.local/bin/mise`), so there's no manual pre-install step.

## Structure

```
dotfiles/
├── .chezmoi.toml.tmpl                         # chezmoi config template (OS detection, email)
├── .chezmoiexternals/
│   └── mise.toml.tmpl                         # Downloads mise binary for current OS/arch
├── .chezmoiscripts/
│   └── run_onchange_after_install-mise-packages.sh.tmpl  # Re-runs mise install on config change
├── dot_bashrc                                 # → ~/.bashrc
├── dot_zshrc                                  # → ~/.zshrc
├── dot_vimrc                                  # → ~/.vimrc
├── dot_config/
│   ├── ghostty/config                         # → ~/.config/ghostty/config
│   ├── mise/config.toml                       # → ~/.config/mise/config.toml
│   └── starship.toml                          # → ~/.config/starship.toml
├── install.sh                                 # DevPod/devcontainer bootstrap entrypoint
└── setup/                                     # Manual setup notes
```

## Usage

### New machine

```bash
# Install chezmoi and apply dotfiles in one step
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply DaltonBuilds
```

chezmoi will download mise, apply all dotfiles, and the `run_onchange` script will install all tools declared in `mise/config.toml`.

### Devcontainers / DevPod

`install.sh` is the entrypoint for DevPod's dotfiles integration. It installs chezmoi if missing, applies dotfiles from the locally cloned repo, and runs `mise install`.

### Keeping in sync

```bash
chezmoi update        # Pull latest from remote and apply
chezmoi apply         # Apply local source state to home directory
chezmoi diff          # Preview what would change
chezmoi edit ~/.zshrc # Edit a managed file and apply
```

## Cross-platform Notes

- `.chezmoi.toml.tmpl` detects OS and sets `is_mac = true/false` — used to conditionally apply macOS-specific config
- The mise external template maps `darwin` → `macos` for the correct binary download URL
- `.zshrc` includes Homebrew (`/opt/homebrew/bin`) and macOS-specific paths; `.bashrc` targets Linux
