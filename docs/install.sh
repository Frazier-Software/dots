#!/bin/bash

# Installation script for dots - the cosmic dotfile manager! 🌌
VERSION="1.1.0"
DOTS_SCRIPT_URL="https://dots.frazier.software/dots.sh"  # Source for the dots script

echo ""
echo ""
echo "🚀 Initiating dots installation v$VERSION! Prepare for liftoff! 🌟"
echo ""

# 1) Check for git
if ! command -v git &> /dev/null; then
  echo "🛸 Houston, we have a problem! Git is not installed! Install it to launch your dotfiles into orbit! 🌌"
  exit 1
fi

# 2) Prompt for DOTFILE_PATH, reading from /dev/tty to work with piped input
echo "🪐 Select a location for your dotfiles repo (default: $HOME/.dotfiles):"
read -p "Enter path: " input_path < /dev/tty
input_path="${input_path:-$HOME/.dotfiles}"
input_path=$(eval echo "$input_path")
DOTFILE_PATH="$input_path"

# 3) Check if directory already exists
if [[ -d "$DOTFILE_PATH" ]]; then
  echo "💥 Alert! A dotfiles repo already exists at $DOTFILE_PATH! Clear the orbit and try again! 🚨"
  exit 1
fi

# 4) Create directory and bin folder
mkdir -p "$DOTFILE_PATH/bin" || {
  echo "🌠 Critical error! Failed to create $DOTFILE_PATH/bin. Check permissions and retry! 🚀"
  exit 1
}

# 5) Download dots script and set executable
echo "📡 Beaming dots script into $DOTFILE_PATH/bin/dots..."
curl -fsSL "$DOTS_SCRIPT_URL" -o "$DOTFILE_PATH/bin/dots" || {
  echo "🌌 Transmission failed! Couldn't download dots script from $DOTS_SCRIPT_URL! 🚨"
  exit 1
}
chmod +x "$DOTFILE_PATH/bin/dots" || {
  echo "💥 Error! Couldn't set executable permissions on $DOTFILE_PATH/bin/dots! 🚀"
  exit 1
}

# 6) Initialize git repo, add files, and commit
cd "$DOTFILE_PATH" || {
  echo "🛸 Navigation error! Couldn't enter $DOTFILE_PATH! 🚨"
  exit 1
}
git init >/dev/null 2>&1 || {
  echo "💥 Git init failed in $DOTFILE_PATH. We're lost in space! 🌑"
  exit 1
}
git add bin/dots >/dev/null 2>&1 || {
  echo "🌠 Failed to add bin/dots to git. Check the system! 🚨"
  exit 1
}
git commit -m "chore: initial commit" >/dev/null 2>&1 || {
  echo "🌌 Commit failed! Unable to log initial commit! 🚨"
  exit 1
}

# 7) Display final instructions
echo ""
echo "--------------------------------------------------"
echo ""
echo "🎉 Mission success! Your dotfiles repo is ready at $DOTFILE_PATH! 🚀"
echo "🛸 Follow these steps to complete your launch sequence:"
echo ""
echo "1. Export DOTFILE_PATH to your shell config (e.g., ~/.bashrc or ~/.zshrc):"
echo "     export DOTFILE_PATH=\"$DOTFILE_PATH\""
echo ""
echo "3. Add the dots binary to your PATH (add to ~/.bashrc or ~/.zshrc):"
echo "     export PATH=\"\$DOTFILE_PATH/bin:\$PATH\""
echo "   Then run: source ~/.bashrc  # or ~/.zshrc"
echo ""
echo "3. Example mission to add a file:"
echo "     dots add ~/.vimrc     # Beam up your vimrc"
echo "     dots                  # Teleport to repo"
echo "     git add -A"
echo "     git commit -m \"feat: added vimrc\""
echo "     exit"
echo ""
echo "🌟 You're now ready to manage your dotfiles in hyperspace! Run 'dots --help' for more commands! 🚀"
exit 0
