#!/bin/bash

# Create dist directory
mkdir -p dist

# Remove old love file if exists
rm -f dist/game.love

# Zip the contents of the project (excluding dist, .git, etc)
# We use -x to exclude files
zip -9 -r dist/game.love . -x "dist/*" -x ".git/*" -x ".vscode/*" -x "*.DS_Store" -x "README.md"

echo "Packaged dist/game.love successfully!"
