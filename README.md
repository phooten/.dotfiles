# General
This project contains file templates, settings, and general configuration files in a central location.
By cloning and installing, I can replicate the same environment across different machines.
It makes it quick to update and propagate changes consistently.

# Requirements
- stow

## Install stow
MacOS:
```bash
brew install stow
```

# Usage
_See requirements if you have trouble._

Install files:
```bash
./dotfiles.sh --install
```

Uninstall files:
```bash
./dotfiles.sh --uninstall
```

Verbose output (prints the script's debug/environment details):
```bash
./dotfiles.sh --verbose --install
./dotfiles.sh -v -u
```

Show help:
```bash
./dotfiles.sh --help
```

Only one action may be used at a time. The script will exit with an error if both install and uninstall are passed in the same command:
```bash
./dotfiles.sh --install --uninstall
```

# Pipelines
This repository includes a basic GitLab CI configuration in [.gitlab-ci.yml](.gitlab-ci.yml) with three stages:

1. `lint` — runs ShellCheck against the installer script and test file
2. `test` — runs the Bash unit tests
3. `release` — runs on the `main` branch after a successful test pipeline and creates a Git tag using the latest entry in [CHANGELOG.md](CHANGELOG.md)

The release job reads the newest version heading in the changelog, for example:

```md
## [1.2.3] - 2026-08-14
```

and creates a matching tag such as:

```bash
v1.2.3
```

The tag is only created when the pipeline succeeds on `main`, and it will skip creation if that tag already exists.

# Testing
Run the unit tests locally from the *repository root*:

```bash
bash tests/test_dotfiles.sh
```

If you want to check the script syntax first:

```bash
bash -n dotfiles.sh
```

# Notes
- The script accepts either long or short flags.
- Verbose mode is optional and only prints additional diagnostic output when enabled.
- The install and uninstall actions are mutually exclusive.

# Repository structure
This repository is organized as a Stow-based dotfiles repo, with each package stored under a dedicated `packages/` directory.

```text
.
├── packages/
│   ├── bash/
│   ├── bin/
│   ├── docker/
│   ├── ssh/
│   ├── tmux/
│   ├── vim/
│   └── vscode/
├── docs/
├── tests/
├── dotfiles.sh
├── README.md
├── .gitlab-ci.yml
└── CHANGELOG.md
```

Each folder under `packages/` is a Stow package. For example, `packages/vim/` contains the files that should be linked into `~/.vim` or the home directory, while `packages/ssh/` contains the SSH configuration files. This keeps the repo organized while matching the Stow package-root convention.

The script uses `STOW_FOLDERS` as the package names, and resolves them relative to `packages/` automatically:

```bash
STOW_FOLDERS=(bash bin docker ssh tmux vim vscode)
```

That means the script effectively installs from:

```text
packages/bash
packages/bin
packages/docker
packages/ssh
packages/tmux
packages/vim
packages/vscode
```

This makes the repo easier to scale without mixing package roots with top-level project files or scripts.
