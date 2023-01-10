#!/bin/bash
# Deploy CouchDB using Helm chart
# Configuration values
RELEASE=''
ADMIN_USER=''
ADMIN_PASSWORD=''
COOKIE_AUTH_SECRET=''
VERSION='4.0.0'
VALUES_FILE='./values-couchdb.yaml'

# Add chart repository
echo "Adding CouchDB repository..."
helm repo add couchdb https://apache.github.io/couchdb-helm

# Create secret credentials for release
echo "Creating credentials for release..."
kubectl create secret generic "$RELEASE-couchdb" \
--from-literal=adminUsername="$ADMIN_USER" \
--from-literal=adminPassword="$ADMIN_PASSWORD" \
--from-literal=cookieAuthSecret="$COOKIE_AUTH_SECRET" \
--from-literal=erlangCookie="$COOKIE_AUTH_SECRET"

echo "Listing secrets..."
kubectl get secrets

# Install the chart
echo "Installing chart..."
helm install "$RELEASE" \
--version "$VERSION" \
--values "$VALUES_FILE" \
couchdb/couchdb