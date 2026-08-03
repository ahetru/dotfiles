# dotfiles

Configuration personnelle, synchronisée via [GNU Stow](https://www.gnu.org/software/stow/)-style symlinks ou l'[install.sh](#installation).

## Structure

```
dotfiles/
├── alacritty/   # ~/.config/alacritty
├── nvim/        # ~/.config/nvim
├── opencode/    # ~/.opencode (skills & AGENTS.md)
├── sway/        # ~/.config/sway          (+ status.sh)
├── waybar/      # ~/.config/waybar
├── wofi/        # ~/.config/wofi
├── shell/       # ~/.zshrc, ~/.zshenv
├── git/         # ~/.gitconfig, ~/.gitignore
├── install.sh   # crée les liens symboliques
└── README.md
```

## Installation

Depuis le dossier du repo :

```sh
./install.sh
```

Le script crée les liens symboliques manquants vers chaque config et s'arrête proprement s'il rencontre un fichier existant qui n'est pas déjà un lien.

## Notes

- `opencode/` vit dans `~/.opencode` (pas dans `~/.config`), il faut un lien dédié si on veut le synchroniser de la même façon.
- `sway/status.sh` est le script de la barre de statut, référencé par la config Sway et par Waybar.