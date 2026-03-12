cat > deploy.sh << 'EOF'
#!/bin/bash
set -e

# Colored output functions
info() { echo -e "\033[1;34m[INFO]\033[0m $1"; }
success() { echo -e "\033[1;32m[SUCCESS]\033[0m $1"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $1"; }

# Script parameter: post title (optional)
POST_TITLE="$1"

# 1️⃣ Create a new post (optional)
if [ -n "$POST_TITLE" ]; then
  POST_FILE="content/posts/$(echo $POST_TITLE | tr '[:upper:]' '[:lower:]' | tr ' ' '-').md"
  info "Creating new post: $POST_FILE"
  hugo new "$POST_FILE"
  # Set draft to false
  sed -i '' 's/draft: true/draft: false/' "$POST_FILE"
fi

# 2️⃣ Build the site
info "Building site with Hugo..."
hugo --gc --minify

# 3️⃣ Copy public/ content to root
info "Copying public/ to root..."
cp -r public/* .

# 4️⃣ Git add / commit / push
info "Adding changes to git..."
git add .
COMMIT_MSG="Deploy site $(date '+%Y-%m-%d %H:%M')"
git commit -m "$COMMIT_MSG" || info "No changes to commit"
git push origin main --force

success "✅ Deploy completed!"
EOF

# Make it executable
chmod +x deploy.sh