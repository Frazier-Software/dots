#!/bin/bash

VERSION="1.0.0"
DOTFILE_PATH="${DOTFILE_PATH:-$HOME/.dotfiles}"

# Check for git
if ! command -v git &> /dev/null; then
  echo "🚀 Houston, we have a problem! Git is not installed! Install it to launch your dotfiles into orbit! 🌌"
  exit 1
fi

# Help flag
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
  echo "⭐ Dots - Dotfile Manager v$VERSION ⭐"
  echo "Usage: dots [command] [options]"
  echo ""
  echo "Commands:"
  echo "  (no args)    Teleport to the dotfiles repo"
  echo "  add <file>   Beam a file into the dotfiles repo"
  echo "  apply        Deploy all dotfiles to their target coordinates"
  echo "  diff         Scan for differences between dotfiles and their repo versions"
  echo "  sync         Update repo with latest system versions of all tracked files"
  echo "  -h, --help   Display this mission briefing"
  echo ""
  echo "Environment:"
  echo "  DOTFILE_PATH  Set custom dotfiles repo path (default: $HOME/.dotfiles)"
  exit 0
fi

# Check if dotfiles repo exists
if [[ ! -d "$DOTFILE_PATH" ]]; then
  echo "🛸 Alert! No dotfiles repo detected at $DOTFILE_PATH!"
  read -p "Initialize a new repo? (y/n): " answer
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    mkdir -p "$DOTFILE_PATH/bin" || {
      echo "🌠 Critical error! Failed to create $DOTFILE_PATH. Check your permissions and retry! 🚀"
      exit 1
    }
    cp "$0" "$DOTFILE_PATH/bin/dots" || {
      echo "🌌 Oops! Couldn't copy dots script to $DOTFILE_PATH/bin. Abort mission! 🚨"
      exit 1
    }
    chmod +x "$DOTFILE_PATH/bin/dots"
    cd "$DOTFILE_PATH" && git init || {
      echo "💥 Git init failed in $DOTFILE_PATH. We're lost in space! 🌑"
      exit 1
    }
    echo "🎉 Mission success! Dotfiles repo initialized at $DOTFILE_PATH! 🚀"
  else
    echo "🪐 Roger that, aborting repo creation. Stay in orbit! 🌟"
    exit 1
  fi
fi

# No args: cd into repo
if [[ $# -eq 0 ]]; then
  (cd "$DOTFILE_PATH" && exec "$SHELL")
  exit 0
fi

# Add command
if [[ "$1" == "add" ]]; then
  if [[ -z "$2" ]]; then
    echo "🌠 Error! Please specify a file to beam up! 📡"
    exit 1
  fi

  src_file="$2"
  if [[ ! -f "$src_file" ]]; then
    echo "🛸 Whoa! $src_file doesn't exist. Can't transport a ghost file! 👾"
    exit 1
  fi

  # Convert to absolute path
  src_file=$(realpath "$src_file")
  filename=$(basename "$src_file")
  src_dir=$(dirname "$src_file")

  # Determine destination based on location
  if [[ "$src_file" == "$HOME"* ]]; then
    rel_path=${src_file#$HOME/}
    dest_dir="$DOTFILE_PATH/home"
  else
    rel_path=${src_file#/}
    dest_dir="$DOTFILE_PATH/root"
  fi

  # Get file permissions (platform-specific)
  if [[ "$(uname)" == "Darwin" ]]; then
    perms=$(stat -f "%Lp" "$src_file" | tr -d '\n')
  else
    perms=$(stat -c "%a" "$src_file")
  fi

  # Transform hidden dirs and files
  IFS='/' read -ra path_parts <<< "$rel_path"
  for part in "${path_parts[@]::${#path_parts[@]}-1}"; do
    if [[ "$part" == .* ]]; then
      dest_dir="$dest_dir/dot_${part#.}"
    else
      dest_dir="$dest_dir/$part"
    fi
  done
  if [[ "$filename" == .* ]]; then
    base_filename="dot_${filename#.}"
  else
    base_filename="$filename"
  fi

  # Apply permission-based prefixes
  case "$perms" in
    600) dest_file="private_${base_filename}" ;;
    400) dest_file="readonly_${base_filename}" ;;
    700) dest_file="privatex_${base_filename}" ;;
    *) dest_file="$base_filename" ;;
  esac

  # Create destination directory
  mkdir -p "$dest_dir" || {
    echo "🌌 Failure! Couldn't create directory $dest_dir. Check permissions! 🚨"
    exit 1
  }

  # Copy file with all attributes
  cp -p "$src_file" "$dest_dir/$dest_file" || {
    echo "💥 Transport failed! Couldn't copy $src_file to $dest_dir/$dest_file! 🚀"
    exit 1
  }

  echo "📡 File $src_file successfully beamed to $dest_dir/$dest_file! 🌟"
  exit 0
fi

# Apply command
if [[ "$1" == "apply" ]]; then
  for section in home root; do
    if [[ -d "$DOTFILE_PATH/$section" ]]; then
      # Collect files to avoid subshell
      mapfile -t repo_files < <(find "$DOTFILE_PATH/$section" -type f)
      for repo_file in "${repo_files[@]}"; do
        # Determine destination path
        rel_path=${repo_file#$DOTFILE_PATH/$section/}
        if [[ "$section" == "home" ]]; then
          dest_path="$HOME"
        else
          dest_path=""
        fi

        # Transform dot_ and permission prefixes back
        IFS='/' read -ra path_parts <<< "$rel_path"
        for part in "${path_parts[@]::${#path_parts[@]}-1}"; do
          if [[ "$part" == dot_* ]]; then
            dest_path="$dest_path/.${part#dot_}"
          else
            dest_path="$dest_path/$part"
          fi
        done
        filename="${path_parts[-1]}"
        if [[ "$filename" == readonly_dot_* ]]; then
          dest_path="$dest_path/.${filename#readonly_dot_}"
          perms=400
        elif [[ "$filename" == private_dot_* ]]; then
          dest_path="$dest_path/.${filename#private_dot_}"
          perms=600
        elif [[ "$filename" == privatex_dot_* ]]; then
          dest_path="$dest_path/.${filename#privatex_dot_}"
          perms=700
        elif [[ "$filename" == readonly_* ]]; then
          dest_path="$dest_path/${filename#readonly_}"
          perms=400
        elif [[ "$filename" == private_* ]]; then
          dest_path="$dest_path/${filename#private_}"
          perms=600
        elif [[ "$filename" == privatex_* ]]; then
          dest_path="$dest_path/${filename#privatex_}"
          perms=700
        elif [[ "$filename" == dot_* ]]; then
          dest_path="$dest_path/.${filename#dot_}"
        else
          dest_path="$dest_path/$filename"
        fi

        dest_dir=$(dirname "$dest_path")
        mkdir -p "$dest_dir" || {
          echo "🌠 Error! Couldn't create directory $dest_dir! 🚨"
          exit 1
        }

        # Check if file exists and overwrite_all is not set
        if [[ -z "$overwrite_all" && -f "$dest_path" ]]; then
          echo "🛸 File $dest_path already exists in the system!"
          read -p "Options: (c)ancel, (s)kip, (o)verwrite, (a)ll: " choice
          case "$choice" in
            [cC]) echo "🌌 Mission aborted! Deployment cancelled! 🚨"; exit 1 ;;
            [sS]) continue ;;
            [oO]) ;;
            [aA]) overwrite_all=1 ;;
            *) echo "💥 Invalid input! Aborting deployment! 🚀"; exit 1 ;;
          esac
        fi

        # Copy file if not skipped
        cp -p "$repo_file" "$dest_path" || {
          echo "🌠 Deploy failed! Couldn't copy $repo_file to $dest_path! 🚨"
          exit 1
        }

        # Set permissions if specified
        if [[ -n "$perms" ]]; then
          chmod "$perms" "$dest_path" || {
            echo "🌠 Warning! Couldn't set permissions $perms on $dest_path! 🚨"
          }
        fi
      done
    fi
  done
  echo "🎉 All dotfiles deployed to their target locations! System is now in hyperspace! 🚀🌟"
  exit 0
fi

# Diff command
if [[ "$1" == "diff" ]]; then
  has_diff=0
  for section in home root; do
    if [[ -d "$DOTFILE_PATH/$section" ]]; then
      # Collect files to avoid subshell
      mapfile -t repo_files < <(find "$DOTFILE_PATH/$section" -type f)
      for repo_file in "${repo_files[@]}"; do
        rel_path=${repo_file#$DOTFILE_PATH/$section/}
        if [[ "$section" == "home" ]]; then
          sys_file="$HOME"
        else
          sys_file=""
        fi

        # Transform dot_ and permission prefixes back
        IFS='/' read -ra path_parts <<< "$rel_path"
        for part in "${path_parts[@]::${#path_parts[@]}-1}"; do
          if [[ "$part" == dot_* ]]; then
            sys_file="$sys_file/.${part#dot_}"
          else
            sys_file="$sys_file/$part"
          fi
        done
        filename="${path_parts[-1]}"
        if [[ "$filename" == readonly_dot_* ]]; then
          sys_file="$sys_file/.${filename#readonly_dot_}"
          expected_perms=400
        elif [[ "$filename" == private_dot_* ]]; then
          sys_file="$sys_file/.${filename#private_dot_}"
          expected_perms=600
        elif [[ "$filename" == privatex_dot_* ]]; then
          sys_file="$sys_file/.${filename#privatex_dot_}"
          expected_perms=700
        elif [[ "$filename" == readonly_* ]]; then
          sys_file="$sys_file/${filename#readonly_}"
          expected_perms=400
        elif [[ "$filename" == private_* ]]; then
          sys_file="$sys_file/${filename#private_}"
          expected_perms=600
        elif [[ "$filename" == privatex_* ]]; then
          sys_file="$sys_file/${filename#privatex_}"
          expected_perms=700
        elif [[ "$filename" == dot_* ]]; then
          sys_file="$sys_file/.${filename#dot_}"
        else
          sys_file="$sys_file/$filename"
        fi

        BLUE='\033[0;34m'
        NC='\033[0m'
        if [[ -f "$sys_file" ]]; then
          # Check permissions
          if [[ -n "$expected_perms" ]]; then
            if [[ "$(uname)" == "Darwin" ]]; then
              actual_perms=$(stat -f "%Lp" "$sys_file" | tr -d '\n')
            else
              actual_perms=$(stat -c "%a" "$sys_file")
            fi
            if [[ "$actual_perms" != "$expected_perms" ]]; then
              echo ""
              echo -e "🛸 ${BLUE}Permission mismatch for $sys_file: expected $expected_perms, found $actual_perms${NC}"
              has_diff=1
            fi
          fi

          # Check content
          if ! cmp -s "$repo_file" "$sys_file"; then
            echo ""
            echo -e "🛸 ${BLUE}Differences detected in $sys_file:${NC}"
            diff -u --color=always "$sys_file" "$repo_file"
            has_diff=1
          fi
        else
          echo ""
          echo -e "🛸 ${BLUE}Missing file $sys_file on host!${NC}"
          has_diff=1
        fi
      done
    fi
  done

  if [[ $has_diff -eq 1 ]]; then
    exit 0
  fi
  echo "🌟 All systems nominal! No differences found between dotfiles and repo! 🚀"
  exit 0
fi

# Sync command
if [[ "$1" == "sync" ]]; then
  for section in home root; do
    if [[ -d "$DOTFILE_PATH/$section" ]]; then
      # Collect files to avoid subshell
      mapfile -t repo_files < <(find "$DOTFILE_PATH/$section" -type f)
      for repo_file in "${repo_files[@]}"; do
        # Determine system path
        rel_path=${repo_file#$DOTFILE_PATH/$section/}
        if [[ "$section" == "home" ]]; then
          sys_file="$HOME"
        else
          sys_file=""
        fi

        # Transform dot_ and permission prefixes back
        IFS='/' read -ra path_parts <<< "$rel_path"
        for part in "${path_parts[@]::${#path_parts[@]}-1}"; do
          if [[ "$part" == dot_* ]]; then
            sys_file="$sys_file/.${part#dot_}"
          else
            sys_file="$sys_file/$part"
          fi
        done
        filename="${path_parts[-1]}"
        if [[ "$filename" == readonly_dot_* ]]; then
          sys_file="$sys_file/.${filename#readonly_dot_}"
        elif [[ "$filename" == private_dot_* ]]; then
          sys_file="$sys_file/.${filename#private_dot_}"
        elif [[ "$filename" == privatex_dot_* ]]; then
          sys_file="$sys_file/.${filename#privatex_dot_}"
        elif [[ "$filename" == readonly_* ]]; then
          sys_file="$sys_file/${filename#readonly_}"
        elif [[ "$filename" == private_* ]]; then
          sys_file="$sys_file/${filename#private_}"
        elif [[ "$filename" == privatex_* ]]; then
          sys_file="$sys_file/${filename#privatex_}"
        elif [[ "$filename" == dot_* ]]; then
          sys_file="$sys_file/.${filename#dot_}"
        else
          sys_file="$sys_file/$filename"
        fi

        # Check if system file exists
        if [[ -f "$sys_file" ]]; then
          # Copy system file to repo with all attributes
          cp -p "$sys_file" "$repo_file" || {
            echo "💥 Sync failed! Couldn't copy $sys_file to $repo_file! 🚨"
            exit 1
          }
        fi
      done
    fi
  done
  echo "🎉 Dotfiles repo synced with latest system versions! Ready for hyperspace! 🚀🌟"
  exit 0
fi

echo "🌌 Unknown command '$1'. Run 'dots --help' for a mission briefing! 🚀"
exit 1
