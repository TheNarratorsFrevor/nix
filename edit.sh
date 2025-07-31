#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(dirname "$(realpath "$0")")"
HOSTS_DIR="$REPO_ROOT/hosts"
EDITOR="vim"
NIXOS_REBUILD_CMD="sudo nixos-rebuild switch --flake"

FZF_DEFAULT_OPTS="
  --height=40%
  --border
  --color=prompt:#61afef,pointer:#98c379,marker:#e5c07b,header:#c678dd
"

get_hosts() {
  find "$HOSTS_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;
}

choose_host() {
  local hosts=($(get_hosts))
  if (( ${#hosts[@]} == 0 )); then
    echo "no hosts found in $HOSTS_DIR" >&2
    exit 1
  elif (( ${#hosts[@]} == 1 )); then
    echo "${hosts[0]}"
  else
    printf '%s\n' "${hosts[@]}" | fzf --prompt="select host > " $FZF_DEFAULT_OPTS || exit 1
  fi
}

choose_file() {
  local host="$1"
  find "$HOSTS_DIR/$host" -type f | fzf --prompt="select file to edit > " $FZF_DEFAULT_OPTS || exit 1
}

format_with_nixpkgs_fmt() {
  local file="$1"
  if command -v nixpkgs-fmt &>/dev/null; then
    nixpkgs-fmt "$file" || echo "warning: nixpkgs-fmt failed on $file" >&2
  else
    echo "warning: nixpkgs-fmt not found, skipping formatting" >&2
  fi
}

commit_changes() {
  local msg="$1"
  git add "$HOSTS_DIR"
  if ! git diff --cached --quiet; then
    echo -e "\e[1;33m▶ staged changes diff:\e[0m"
    git --no-pager diff --color=always --cached | less -R
    echo -e "\n\e[1;36m⏳ committing changes...\e[0m"
    if [[ "$msg" == "edit "* ]]; then
      msg+=" @$(date '+%Y-%m-%d %H:%M:%S')"
    fi
    git commit -m "$msg"
    echo -e "\e[1;32m✔ commit done\e[0m"
  else
    echo -e "\e[1;31m⚠ no changes to commit\e[0m"
  fi
}

prompt_confirm() {
  while true; do
    read -rp $'\e[1;34mProceed with nixos-rebuild? [y/N]: \e[0m' yn
    case $yn in
      [Yy]*) return 0 ;;
      [Nn]*|"" ) return 1 ;;
      *) echo "please answer y or n." ;;
    esac
  done
}

switch_config() {
  local host="$1"
  echo -e "\e[1;35mSwitching to host config: $host\e[0m"
  if prompt_confirm; then
    echo -e "\e[1;33mRunning nixos-rebuild...\e[0m"
    $NIXOS_REBUILD_CMD "$REPO_ROOT#$host"
    echo -e "\e[1;32mNixos-rebuild completed!\e[0m"
  else
    echo -e "\e[1;31mNixos-rebuild skipped\e[0m"
  fi
}

usage() {
  cat <<EOF
usage: $0 [-m commit-message]

options:
  -m  custom commit message (default: "edit <file>")
EOF
  exit 1
}

main() {
  local host file commit_msg default_msg

  commit_msg=""
  while getopts ":m:" opt; do
    case $opt in
      m) commit_msg="$OPTARG" ;;
      *) usage ;;
    esac
  done
  shift $((OPTIND -1))

  host=$(choose_host)
  file=$(choose_file "$host")

  format_with_nixpkgs_fmt "$file"
  $EDITOR "$file"

  default_msg="edit $(basename "$file")"
  [[ -z "$commit_msg" ]] && commit_msg="$default_msg"

  commit_changes "$commit_msg"
  switch_config "$host"
}

main "$@"

