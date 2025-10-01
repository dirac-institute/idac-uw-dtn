#!/bin/bash
set -e

CERTS_DIR="certs"
mkdir -p "$CERTS_DIR"

CA_DIR="ca"
mkdir -p "$CA_DIR"

HOST=$1

echo "Generating certificate for ${HOST}"

# Generate host certificate
openssl genrsa -out "$CERTS_DIR/${HOST}.key" 2048
openssl req -new -key "$CERTS_DIR/${HOST}.key" -out "$CERTS_DIR/${HOST}.csr" -subj "/C=US/ST=DevState/L=DevCity/O=DevOrg/OU=DevUnit/CN=${HOST}" 
openssl x509 -req -in "$CERTS_DIR/${HOST}.csr" -CA "$CA_DIR/ca.crt" -CAkey "$CA_DIR/ca.key" -CAcreateserial -out "$CERTS_DIR/${HOST}.crt" -days 365 -extensions v3_req -extfile ./${HOST}_cert.cfg
