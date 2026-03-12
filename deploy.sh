#!/bin/bash
set -e

# Colored output functions
info() { echo -e "\033[1;34m[INFO]\033[0m $1"; }
success() { echo -e "\033[1;32m[SUCCESS]\033[0m $1"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $1"; }

# 1️⃣ Build the site
info "Building site with Hugo..."
hugo --gc --minify

# 2️⃣ Copy public/ content to root
info "Copying public/ to root..."
cp -r public/* .

# 3️⃣ Git add / commit / push
info "Adding changes to git..."
git add .
COMMIT_MSG="Deploy site $(date '+%Y-%m-%d %H:%M')"
git commit -m "$COMMIT_MSG" || info "No changes to commit"
git push origin main --force

success "✅ Deploy completed!"