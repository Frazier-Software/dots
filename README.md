# Dots - Cosmic Dotfile Manager 🌌

<br>
<div align="center">
  <a href="https://github.com/Frazier-Software/dots">
    <img src="logo.png" alt="Logo" width="192" height="192">
  </a>
</div>
<br>

**Dots** is your interstellar command center for managing dotfiles with ease and flair! Whether you're beaming up new configs or deploying them across systems, Dots keeps your setup in hyperspace. With a single command, you can add, sync, diff, or apply your dotfiles, all while enjoying a playful, space-themed experience. Ready to launch? Try this:

```shell
dots add ~/.vimrc  # Beam up your vimrc
dots               # Teleport to your repo
git commit -a -m "feat: added vimrc"
```

No more messy symlinks or manual copying—Dots handles the heavy lifting, so you can focus on exploring the universe of your perfect setup! 🚀

## Usage 📡

Dots comes with a stellar set of commands to manage your dotfiles. Run `dots --help` to see the full mission briefing:

```
⭐ Dots - Dotfile Manager v0.0.1 ⭐
Usage: dots [command] [options]

Commands:
  (no args)    Teleport to the dotfiles repo
  add <file>   Beam a file into the dotfiles repo
  apply        Deploy all dotfiles to their target coordinates
  diff         Scan for differences between dotfiles and their repo versions
  sync         Update repo with latest system versions of all tracked files
  -h, --help   Display this mission briefing

Environment:
  DOTFILE_PATH  Set custom dotfiles repo path (default: $HOME/.dotfiles)
```

## Features 🚀

- **Smart File Handling**: Automatically transforms hidden files (e.g., `.zshrc`) into repo-friendly names (e.g., `dot_zshrc`) and back.
- **Safe Deployment**: Prompts before overwriting existing files during `apply`.
- **Diff Scanning**: Compares system files with repo versions to spot anomalies.
- **Git Integration**: Works seamlessly with your git workflow for version control.
- **Customizable**: Set `DOTFILE_PATH` to any location for ultimate flexibility.
- **Playful UX**: Space-themed messages make managing dotfiles a blast!

## Why Dots? 🌑

Unlike other dotfile managers, Dots is lightweight, bash-powered, and packed with personality. No dependencies beyond git, no complex setup—just pure, cosmic simplicity. Whether you're a lone astronaut or a fleet commander, Dots scales to your needs without leaving you lost in space.

## FAQ 🛸

**Q: Where are my dotfiles stored?**  
A: In your `DOTFILE_PATH` (default: `~/.dotfiles`). Files are organized into `home/` for user configs and `root/` for system-wide ones.

**Q: What if I mess up?**  
A: Run `dots diff` to spot issues, or use git to revert changes. Your repo is your safety net!

**Q: Can I use Dots without git?**  
A: Git is required for repo initialization and tracking, but Dots makes it easy to track, commit, and push.

## License 📜

Released under the [MIT License](LICENSE.txt). Beam it, fork it, share it—just keep the good vibes in orbit!

---

*Built with ❤️ and a touch of AI by Frazier Software. Run `dots` and explore the universe of your configs!*
