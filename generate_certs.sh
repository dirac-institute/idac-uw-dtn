#!/bin/bash
set -e

CERTS_DIR="certs"
mkdir -p "$CERTS_DIR"

CA_DIR="ca"
mkdir -p "$CA_DIR"

echo "Generating self-signed certificates for development..."

# Generate CA key and certificate
openssl genrsa -out "$CA_DIR/ca.key" 2048
openssl req -new -x509 -key "$CA_DIR/ca.key" -out "$CA_DIR/ca.crt" -days 365 -subj "/C=US/ST=DevState/L=DevCity/O=DevOrg/OU=DevUnit/CN=DevCA"

# Create a copy of the CA Certificate which is named for its hash
SUBJECT_HASH=$(openssl x509 -in "$CA_DIR/ca.crt" -noout -subject_hash)
cp "$CA_DIR/ca.crt" "$CA_DIR/${SUBJECT_HASH}.0"

./generate_cert.sh rohan
./generate_cert.sh client
./generate_cert.sh rohan.astro.washington.edu

# Clean up CSRs
#rm -f "$CERTS_DIR"/*.csr

# Create CA bundle
cp "$CA_DIR/ca.crt" "$CA_DIR/ca-bundle.crt"

# Set proper permissions
chmod 644 "$CERTS_DIR"/*.crt "$CA_DIR"/*.crt
chmod 600 "$CERTS_DIR"/*.key "$CA_DIR"/*.key

echo "Certificates generated in $CERTS_DIR/ and $CA_DIR/"