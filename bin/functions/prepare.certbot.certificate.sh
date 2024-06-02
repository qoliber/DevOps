#!/usr/bin/env bash

prepare_certbot_certificate() {
  local CLOUD_FLARE_API_TOKEN="$1"
  local DOMAIN="$2"
  local CERT_DOMAIN=$(echo "$DOMAIN" | awk -F '.' '{if (NF>2) print $(NF-2)"."$(NF-1)"."$NF; else print $0;}')

  # remove double subdomain, or more prefix
  IFS='.' read -r -a domain_parts <<< "$DOMAIN"

  # Count the number of parts in the domain
  num_parts=${#domain_parts[@]}

  # Check if there are more than three parts (indicating more than one subdomain)
  if [[ $num_parts -gt 3 ]]; then
      # More than one subdomain, prepend '*.' to the second and following parts
      DOMAIN="*.${domain_parts[@]:1}"
      DOMAIN="${DOMAIN// /'.'}" # Replace spaces with dots
  else
      # One or no subdomain, use the domain as is
      DOMAIN="${domain_parts[*]}"
      DOMAIN="${DOMAIN// /'.'}" # Replace spaces with dots
  fi

  mkdir -p ~/.secret
  touch ~/.secret/cloudflare.ini
  echo "dns_cloudflare_api_token = $CLOUD_FLARE_API_TOKEN" > ~/.secret/cloudflare.ini
  chmod 0600 ~/.secret/cloudflare.ini

  sudo ldconfig /lib/x86_64-linux-gnu/

  certbot certonly \
    --non-interactive \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --domains "$DOMAIN" \
    --agree-tos -m setup@qsolutionsstudio.com \
    --dns-cloudflare \
    --dns-cloudflare-credentials ~/.secret/cloudflare.ini \
    --dns-cloudflare-propagation-seconds 15 \
    --config-dir="/etc/letsencrypt/" \
    --cert-name $CERT_DOMAIN

}