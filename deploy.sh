#!/bin/bash
set -e

info() { echo -e "\033[1;34m[INFO]\033[0m $1"; }
success() { echo -e "\033[1;32m[SUCCESS]\033[0m $1"; }

info "Building site..."
hugo --gc --minify

info "Adding changes to git..."
git add .
git commit -m "Deploy site $(date '+%Y-%m-%d %H:%M')" || echo "No changes to commit"
git push origin main --force

success "✅ Deploy completed!"