#!/bin/sh

CERT_DIR=/etc/nginx/certs

# Überprüfen ob Zertifikate bereits existieren
if [ ! -f "$CERT_DIR/nginx1.crt" ] || [ ! -f "$CERT_DIR/nginx1.key" ]; then
  echo "Erstelle Zertifikate..."

  mkdir -p $CERT_DIR

  # CA erstellen
  openssl genpkey -algorithm RSA -out $CERT_DIR/ca.key
  openssl req -new -x509 -key $CERT_DIR/ca.key -out $CERT_DIR/ca.crt -subj "/CN=example-ca"

  # Zertifikate für die Webserver erstellen
  for i in 1 2 3; do
    openssl genpkey -algorithm RSA -out $CERT_DIR/nginx$i.key
    openssl req -new -key $CERT_DIR/nginx$i.key -out $CERT_DIR/nginx$i.csr -subj "/CN=nginx$i.automa-it.work"
    openssl x509 -req -in $CERT_DIR/nginx$i.csr -CA $CERT_DIR/ca.crt -CAkey $CERT_DIR/ca.key -CAcreateserial -out $CERT_DIR/nginx$i.crt -days 365
  done

  # Markiere den erfolgreichen Abschluss durch Erstellen einer Datei
  touch $CERT_DIR/.certs_created

else
  echo "Zertifikate bereits vorhanden. Überspringe Erstellung."
  # Markiere als erfolgreich abgeschlossen, falls die Zertifikate bereits existieren
  touch $CERT_DIR/.certs_created
fi

# Beende das Skript und den Container erfolgreich
echo "Zertifikate erfolgreich erstellt. Beende Container."
exit 0
