#!/bin/bash
set -e

info() { echo -e "\033[1;34m[INFO]\033[0m $1"; }
success() { echo -e "\033[1;32m[SUCCESS]\033[0m $1"; }

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$BUILD_DIR"
}

trap cleanup EXIT

info "Building site into a temporary directory..."
hugo --gc --minify --destination "$BUILD_DIR"

info "Syncing generated site to repository root..."
rsync -a --delete \
  --exclude '.git/' \
  --exclude '.gitmodules' \
  --exclude '.DS_Store' \
  --exclude '.hugo_build.lock' \
  --exclude 'archetypes/' \
  --exclude 'content/' \
  --exclude 'deploy.sh' \
  --exclude 'hugo.toml' \
  --exclude 'public/' \
  --exclude 'resources/' \
  --exclude 'themes/' \
  "$BUILD_DIR"/ "$ROOT_DIR"/

info "Syncing generated site to public/..."
mkdir -p "$ROOT_DIR/public"
rsync -a --delete "$BUILD_DIR"/ "$ROOT_DIR/public"/

info "Adding changes to git..."
git add .
git commit -m "Deploy site $(date '+%Y-%m-%d %H:%M')" || echo "No changes to commit"
git push origin main --force

success "✅ Deploy completed!"
