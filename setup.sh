#!/bin/bash
set -e

echo "Setting up XRootD DTN Stack..."

# Make scripts executable
chmod +x generate_certs.sh generate_auth_files.sh

# Generate certificates
echo "1. Generating certificates..."
./generate_certs.sh

# Generate auth files  
echo "2. Generating authentication files..."
./generate_auth_files.sh

# Create data directory
echo "3. Creating data directory..."
mkdir -p data
echo "Test file for XRootD" > data/test.txt

echo ""
echo "Setup complete! You can now run:"
echo "  docker-compose up --build"
echo ""