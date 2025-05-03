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
git add -A
git commit -m "feat: added vimrc"
```

No more messy symlinks or manual copying—Dots handles the heavy lifting, so you can focus on exploring the universe of your perfect setup! 🚀

## Installation 🚀

Launch Dots on a new system in minutes with these steps. Get ready to enter orbit!

### Fresh Install 🌟

1. **Install Dots** using our cosmic one-liner:
   ```shell
   curl https://dots.frazier.software/install.sh | bash
   ```

2. **Follow the prompts** to choose your dotfiles repo location (default: `~/.dotfiles`).

3. **Set up your environment** as instructed:
   ```shell
   # Add to ~/.bashrc or ~/.zshrc
   export DOTFILE_PATH="$HOME/.dotfiles"
   export PATH="$DOTFILE_PATH/bin:$PATH"
   ```
   Then reload your shell:
   ```shell
   source ~/.bashrc  # or ~/.zshrc
   ```

4. **Start your mission**:
   ```shell
   dots add ~/.vimrc  # Beam up a file
   dots               # Teleport to repo
   git add -A
   git commit -m "feat: added vimrc"
   ```

### Restoring an Existing Dots Repo 🪐

Got a Dots repo from another galaxy? Here's how to bring it to a new system:

1. **Clone your repo**:
   ```shell
   git clone <your-repo-url> ~/.dotfiles
   ```

2. **Set environment variables**:
   ```shell
   # Add to ~/.bashrc or ~/.zshrc
   export DOTFILE_PATH="$HOME/.dotfiles"
   export PATH="$DOTFILE_PATH/bin:$PATH"
   ```
   Reload your shell:
   ```shell
   source ~/.bashrc  # or ~/.zshrc
   ```

3. **Verify your setup**:
   ```shell
   dots diff  # Scan for differences
   ```

4. **Deploy your dotfiles**:
   ```shell
   dots apply  # Beam configs to their destinations
   ```

Your system is now in sync with your cosmic configs! 🌠

## Usage 📡

Dots comes with a stellar set of commands to manage your dotfiles. Run `dots --help` to see the full mission briefing:

```
⭐ Dots - Dotfile Manager v1.1.0 ⭐
Usage: dots [command] [options]

Commands:
  (no args)        Teleport to the dotfiles repo
  add <file>       Beam a file into the dotfiles repo
  apply            Deploy all dotfiles to their target coordinates
  diff             Scan for differences between dotfiles and their repo versions
  sync             Update repo with latest system versions of all tracked files
  encrypt <file>   Securely beam a file into the vault with GPG encryption
  decrypt          Deploy all encrypted vault files to their target coordinates
  verify           Scan for differences between vault files and their system versions
  -h, --help       Display this mission briefing

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
- **GPG Encryption**: Protect sensitive dotfiles with GPG.

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
