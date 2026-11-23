# Universal Automated Setup Prompt for Kitty, Neovim (NvChad), and Fastfetch

> **Instructions for the AI Assistant**:
> You are tasked with setting up and configuring the complete environment for **Kitty**, **Neovim (NvChad v2.5)**, and **Fastfetch** from scratch using the configuration files provided in this repository (`config_files/`).
> Execute all steps autonomously in sequence, ensuring dependencies are installed, paths are resolved, plugins are bootstrapped, and configurations are verified without requiring user intervention.

---

## 🎯 Goal
Restore and configure the exact working setup for:
1. **Kitty**: High-performance Wayland/X11 terminal with JetBrainsMono Nerd Font, 0.75 background opacity, 30 blur, and Adwaita darker theme.
2. **Neovim (NvChad v2.5)**: Full IDE setup featuring Catppuccin pure black `#000000` base, `#ed333b` Katana crimson highlights, transparent backgrounds, wider NvimTree (width 38), and lazy-loaded plugins.
3. **Fastfetch**: Custom boxed hardware/software layout featuring the custom high-resolution Katana artwork logo.

---

## 🚀 Execution Steps for the AI

### Step 1: Detect OS & Install Required Dependencies

Detect the distribution package manager and install the core binaries, fonts, and Neovim compilation prerequisites:

#### On Arch Linux / CachyOS / Manjaro:
```bash
sudo pacman -S --needed --noconfirm \
    kitty \
    neovim \
    fastfetch \
    git \
    curl \
    rsync \
    ripgrep \
    fd \
    gcc \
    make \
    unzip \
    tar \
    nodejs \
    npm \
    ttf-jetbrains-mono-nerd
```

#### On Fedora:
```bash
sudo dnf install -y \
    kitty \
    neovim \
    fastfetch \
    git \
    curl \
    rsync \
    ripgrep \
    fd-find \
    gcc \
    make \
    unzip \
    tar \
    nodejs \
    npm \
    jetbrains-mono-fonts-all
```

#### On Debian / Ubuntu:
```bash
sudo apt update && sudo apt install -y \
    kitty \
    neovim \
    fastfetch \
    git \
    curl \
    rsync \
    ripgrep \
    fd-find \
    build-essential \
    unzip \
    tar \
    nodejs \
    npm
# Ensure a Nerd Font (JetBrainsMono Nerd Font) is installed in ~/.local/share/fonts
```

---

### Step 2: Deploy Configuration Files

Locate the `config_files/` folder (or repository root) and copy the configurations to the user's `$HOME/.config/` directory. If existing configurations exist, safely create a timestamped backup before deploying.

```bash
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
REPO_DIR="$(pwd)"

# If running from inside the repo or config_files parent directory:
if [ -d "$REPO_DIR/config_files" ]; then
    SOURCE_DIR="$REPO_DIR/config_files"
else
    SOURCE_DIR="$REPO_DIR"
fi

# 1. Kitty Setup
mkdir -p "$CONFIG_DIR/kitty"
if [ -f "$CONFIG_DIR/kitty/kitty.conf" ]; then
    cp "$CONFIG_DIR/kitty/kitty.conf" "$CONFIG_DIR/kitty/kitty.conf.bak.$(date +%s)"
fi
cp -rf "$SOURCE_DIR/kitty/"* "$CONFIG_DIR/kitty/"

# 2. Fastfetch Setup
mkdir -p "$CONFIG_DIR/fastfetch" "$CONFIG_DIR/Fastfetch"
cp -rf "$SOURCE_DIR/fastfetch/"* "$CONFIG_DIR/fastfetch/"

# Dynamically patch user home path in config.jsonc so the logo loads for any username
sed -i "s|\"/home/[^/]*/\.config/fastfetch/katana\.png\"|\"$HOME/.config/fastfetch/katana.png\"|g" "$CONFIG_DIR/fastfetch/config.jsonc"

# Symlink lowercase to uppercase for compatibility
ln -sf "$CONFIG_DIR/fastfetch/config.jsonc" "$CONFIG_DIR/Fastfetch/config.jsonc"
ln -sf "$CONFIG_DIR/fastfetch/katana.png" "$CONFIG_DIR/Fastfetch/katana.png" 2>/dev/null || true
ln -sf "$CONFIG_DIR/fastfetch/katana_black.png" "$CONFIG_DIR/Fastfetch/katana_black.png" 2>/dev/null || true

# 3. Neovim Setup (NvChad)
mkdir -p "$CONFIG_DIR/nvim"
if [ -f "$CONFIG_DIR/nvim/init.lua" ]; then
    mv "$CONFIG_DIR/nvim" "$CONFIG_DIR/nvim.bak.$(date +%s)"
    mkdir -p "$CONFIG_DIR/nvim"
fi
rsync -av --exclude='.git' "$SOURCE_DIR/nvim/" "$CONFIG_DIR/nvim/"
```

---

### Step 3: Bootstrap Neovim & Lazy Plugins

Neovim uses NvChad v2.5 and Lazy.nvim. Run Neovim headlessly to clone Lazy.nvim, install plugins from `lazy-lock.json`, and compile the Catppuccin / Base46 theme cache:

```bash
# Clean stale plugin cache if needed
rm -rf "$HOME/.local/share/nvim/base46" 2>/dev/null || true

# Bootstrap plugins headlessly
nvim --headless "+Lazy! restore" +qa 2>/dev/null || nvim --headless "+Lazy! sync" +qa

# Compile NvChad theme cache
nvim --headless "+lua require('nvconfig'); pcall(function() require('base46').compile() end)" +qa 2>/dev/null || true
```

---

### Step 4: Verification & Smoke Testing

Run automated checks to confirm all three applications are fully functional:

```bash
echo "=== 1. Checking Kitty ==="
kitty --version

echo "=== 2. Checking Fastfetch ==="
fastfetch --load-config "$HOME/.config/fastfetch/config.jsonc"

echo "=== 3. Checking Neovim ==="
nvim --version | head -n 2
nvim --headless "+checkhealth lazy" +qa
```

---

### 🛡️ Expected Outcome
- **Kitty**: Launches with blur, transparency, JetBrainsMono Nerd Font, and native Adwaita Darker theme.
- **Fastfetch**: Prints the system overview cleanly with the Katana graphic logo aligned with hardware and software telemetry.
- **Neovim**: Opens instantly into NvChad with transparent background, pure black Catppuccin palette, crimson red accents, file tree, statusline, and lspconfig without errors.
