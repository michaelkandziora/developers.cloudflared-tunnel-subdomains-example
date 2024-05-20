#!/bin/sh

# Define directories
CERT_DIR="./certs"
NGINX1_DIR="./nginx1/certs"
NGINX2_DIR="./nginx2/certs"
NGINX3_DIR="./nginx3/certs"

# Create the target directories if they don't exist
mkdir -p $NGINX1_DIR $NGINX2_DIR $NGINX3_DIR

# Copy the certificates to the respective directories
if [ -f "$CERT_DIR/nginx1.crt" ] && [ -f "$CERT_DIR/nginx1.key" ]; then
  cp "$CERT_DIR/nginx1.crt" "$NGINX1_DIR/nginx1.crt"
  cp "$CERT_DIR/nginx1.key" "$NGINX1_DIR/nginx1.key"
  echo "Zertifikate für nginx1 kopiert."
else
  echo "Zertifikate für nginx1 nicht gefunden."
fi

if [ -f "$CERT_DIR/nginx2.crt" ] && [ -f "$CERT_DIR/nginx2.key" ]; then
  cp "$CERT_DIR/nginx2.crt" "$NGINX2_DIR/nginx2.crt"
  cp "$CERT_DIR/nginx2.key" "$NGINX2_DIR/nginx2.key"
  echo "Zertifikate für nginx2 kopiert."
else
  echo "Zertifikate für nginx2 nicht gefunden."
fi

if [ -f "$CERT_DIR/nginx3.crt" ] && [ -f "$CERT_DIR/nginx3.key" ]; then
  cp "$CERT_DIR/nginx3.crt" "$NGINX3_DIR/nginx3.crt"
  cp "$CERT_DIR/nginx3.key" "$NGINX3_DIR/nginx3.key"
  echo "Zertifikate für nginx3 kopiert."
else
  echo "Zertifikate für nginx3 nicht gefunden."
fi

