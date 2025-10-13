
# 🗂️ Dotfiles

My personal dotfiles for setting up a customized Linux environment, especially designed for minimal and efficient window managers like Hyprland and i3. This setup is organized using [GNU Stow](https://www.gnu.org/software/stow/) for easy symlink management.

## 📁 Structure

This repo follows the stow-compatible layout:

```
dotfiles/
├── alacritty/.config/alacritty/
├── fontconfig/.config/fontconfig/
├── hypr/.config/hypr/
├── nvim/.config/nvim/
├── waybar/.config/waybar/
├── wofi/.config/wofi/
└── zshrc/.zshrc
```

## 🚀 Usage

### 1. Clone the repository

```bash
git clone https://github.com/Hasib-4174/dotfiles.git
cd dotfiles
```

### 2. Install GNU Stow (if not already installed)

```bash
# For Arch-based distros
sudo pacman -S stow

# For Debian/Ubuntu
sudo apt install stow
```

### 3. Stow the modules

You can stow any configuration folder like this:

```bash
stow alacritty
stow nvim
stow hypr
stow waybar
stow wofi
stow fontconfig
stow zshrc
```

It will automatically symlink to your home directory (`~/.config/...` or `~/.zshrc`).

## 🧰 Tools Covered

- [Alacritty](https://github.com/alacritty/alacritty) - Terminal emulator
- [Fontconfig](https://wiki.archlinux.org/title/font_configuration)
- [Hyprland](https://github.com/hyprwm/Hyprland) - Wayland compositor
- [Neovim](https://neovim.io/) - Text editor
- [Waybar](https://github.com/Alexays/Waybar) - Status bar for Wayland
- [Wofi](https://hg.sr.ht/~scoopta/wofi) - Application launcher
- [Zsh](https://www.zsh.org/) - Shell

## 📌 Notes

- Make sure to back up existing config files before using `stow`.
- Designed for use with **Wayland** systems using Hyprland.

## 🧑 Profile

**Hasib-4174**  
📎 [GitHub Profile](https://github.com/Hasib-4174)

---

Feel free to customize or fork the dotfiles for your own setup!
