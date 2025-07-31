#!/usr/bin/env bash
set -euo pipefail

# config
REPO_ROOT="$(dirname "$(realpath "$0")")"
HOSTS_DIR="$REPO_ROOT/hosts"
EDITOR="${EDITOR:-vim}"
NIXOS_REBUILD_CMD="sudo nixos-rebuild switch --flake"

# colors for fzf prompt
FZF_DEFAULT_OPTS="
  --height=40%
  --border
  --color=prompt:#61afef,pointer:#98c379,marker:#e5c07b,header:#c678dd
"

# get hosts list
get_hosts() {
  find "$HOSTS_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;
}

# select host (auto if one, else fzf)
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

# select file under a host
choose_file() {
  local host="$1"
  find "$HOSTS_DIR/$host" -type f | fzf --prompt="select file to edit > " $FZF_DEFAULT_OPTS || exit 1
}

# commit changes with tags
commit_changes() {
  local msg="$1"
  git add "$HOSTS_DIR"
  if ! git diff --cached --quiet; then
    git commit -m "$msg"
  else
    echo "no changes to commit"
  fi
}

# show git diff for hosts dir
show_diff() {
  git --no-pager diff "$HOSTS_DIR" || true
}

# rebuild nixos config with selected host
switch_config() {
  local host="$1"
  echo -e "\e[1;34mswitching to host config: $host\e[0m"
  $NIXOS_REBUILD_CMD "$REPO_ROOT#$host"
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

  $EDITOR "$file"

  default_msg="edit $(basename "$file")"
  [[ -z "$commit_msg" ]] && commit_msg="$default_msg"

  commit_changes "$commit_msg"
  show_diff
  switch_config "$host"
}

main "$@"

