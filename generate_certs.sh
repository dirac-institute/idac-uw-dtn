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

# Generate Rohan certificate (proxy server)
openssl genrsa -out "$CERTS_DIR/rohan.key" 2048
openssl req -new -key "$CERTS_DIR/rohan.key" -out "$CERTS_DIR/rohan.csr" -subj "/C=US/ST=DevState/L=DevCity/O=DevOrg/OU=DevUnit/CN=rohan" 
openssl x509 -req -in "$CERTS_DIR/rohan.csr" -CA "$CA_DIR/ca.crt" -CAkey "$CA_DIR/ca.key" -CAcreateserial -out "$CERTS_DIR/rohan.crt" -days 365 -extensions v3_req -extfile ./rohan_cert.cfg

# Generate client certificate for testing
openssl genrsa -out "$CERTS_DIR/client.key" 2048
openssl req -new -key "$CERTS_DIR/client.key" -out "$CERTS_DIR/client.csr" -subj "/C=US/ST=DevState/L=DevCity/O=DevOrg/OU=DevUnit/CN=testuser"
openssl x509 -req -in "$CERTS_DIR/client.csr" -CA "$CA_DIR/ca.crt" -CAkey "$CA_DIR/ca.key" -CAcreateserial -out "$CERTS_DIR/client.crt" -days 365 -extensions v3_req -extfile ./client_cert.cfg

# Clean up CSRs
#rm -f "$CERTS_DIR"/*.csr

# Create CA bundle
cp "$CA_DIR/ca.crt" "$CA_DIR/ca-bundle.crt"

# Set proper permissions
chmod 644 "$CERTS_DIR"/*.crt "$CA_DIR"/*.crt
chmod 600 "$CERTS_DIR"/*.key "$CA_DIR"/*.key

echo "Certificates generated in $CERTS_DIR/ and $CA_DIR/"