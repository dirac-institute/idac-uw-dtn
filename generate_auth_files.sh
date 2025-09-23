#!/bin/bash
set -e

AUTH_DIR="auth"
mkdir -p "$AUTH_DIR"

echo "Generating XRootD authentication files..."

# Generate shared secret key for SSS authentication
yes | xrdsssadmin -u xrootd -k "xrootd_secret" add $AUTH_DIR/sss.keytab

# Create authorization file
# Simple authfile allowing all authenticated users read/write access
cat > "$AUTH_DIR/authfile" << 'EOF'
# XRootD Authorization File
# Format: template [s:<subject>] [g:<group>] [role] path access
# Only allow xrootd user access to /data.

u xrootd /data a
EOF

# Set proper permissions
chmod 600 "$AUTH_DIR/sss.keytab"
chmod 644 "$AUTH_DIR/authfile"

echo "Authentication files generated in $AUTH_DIR/"
echo "Files created:"
echo "  sss.keytab - Shared secret for shire<->rohan communication"
echo "  authfile - Authorization rules"