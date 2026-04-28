#!/bin/bash
# Email Verifier Setup Wizard Build Script
# Automatically downloads bundled Node.js and creates installer

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Email Verifier Setup Wizard Builder"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Detect OS
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    OS="win"
    ARCH="x64"
    NODE_FILENAME="node-v18.17.1-win-x64.zip"
    NODE_URL="https://nodejs.org/dist/v18.17.1/node-v18.17.1-win-x64.zip"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="osx"
    ARCH=$(uname -m)
    if [[ "$ARCH" == "arm64" ]]; then
        NODE_FILENAME="node-v18.17.1-darwin-arm64.tar.gz"
        NODE_URL="https://nodejs.org/dist/v18.17.1/node-v18.17.1-darwin-arm64.tar.gz"
    else
        NODE_FILENAME="node-v18.17.1-darwin-x64.tar.gz"
        NODE_URL="https://nodejs.org/dist/v18.17.1/node-v18.17.1-darwin-x64.tar.gz"
    fi
elif [[ "$OSTYPE" == "linux"* ]]; then
    OS="linux"
    ARCH="x64"
    NODE_FILENAME="node-v18.17.1-linux-x64.tar.gz"
    NODE_URL="https://nodejs.org/dist/v18.17.1/node-v18.17.1-linux-x64.tar.gz"
else
    echo "❌ Unsupported operating system"
    exit 1
fi

echo "✓ Detected OS: $OS ($ARCH)"
echo ""

# Step 1: Install npm dependencies
echo "📦 Installing npm dependencies..."
npm install > /dev/null 2>&1
echo "✓ Dependencies installed"
echo ""

# Step 2: Download Node.js portable
echo "⬇️  Downloading portable Node.js..."
mkdir -p node-portable
mkdir -p temp-node

if command -v curl &> /dev/null; then
    curl -L "$NODE_URL" -o "temp-node/$NODE_FILENAME" --progress-bar
elif command -v wget &> /dev/null; then
    wget -O "temp-node/$NODE_FILENAME" "$NODE_URL"
else
    echo "❌ Neither curl nor wget found. Please install one to continue."
    exit 1
fi

echo "✓ Node.js downloaded"
echo ""

# Step 3: Extract Node.js
echo "📂 Extracting Node.js..."
if [[ "$OS" == "win" ]]; then
    # For Windows, use PowerShell to extract zip
    powershell -Command "Expand-Archive -Path 'temp-node/$NODE_FILENAME' -DestinationPath 'temp-node' -Force"
    cp -r temp-node/node-v*/. node-portable/
else
    # For Mac and Linux, use tar
    tar -xzf "temp-node/$NODE_FILENAME" -C temp-node
    cp -r temp-node/node-v*/. node-portable/
fi

echo "✓ Node.js extracted"
echo ""

# Step 4: Verify Node.js
echo "✓ Verifying Node.js..."
if [[ "$OS" == "win" ]]; then
    ./node-portable/node.exe --version > /dev/null 2>&1
else
    ./node-portable/bin/node --version > /dev/null 2>&1
fi
echo "✓ Node.js verified"
echo ""

# Step 5: Clean up
echo "🧹 Cleaning up temporary files..."
rm -rf temp-node
echo "✓ Cleanup complete"
echo ""

# Step 6: Build installer
echo "🏗️  Building installer..."
if [[ "$OS" == "win" ]]; then
    npm run build-win
elif [[ "$OS" == "osx" ]]; then
    npm run build-mac
else
    echo "❌ Linux building not yet configured. Please use Windows or Mac."
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✓ Build Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Your installer is ready in the 'dist' folder:"
if [[ "$OS" == "win" ]]; then
    echo "  📦 EmailVerifier-Setup.exe"
else
    echo "  📦 EmailVerifier.dmg"
fi
echo ""
echo "Users can now download and run this installer."
echo "No additional software installation needed!"
echo ""
