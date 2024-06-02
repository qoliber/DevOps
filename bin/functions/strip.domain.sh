#!/usr/bin/env bash

strip_subdomain() {
    local full_domain="$1"
    # Extract the main domain along with the TLD by removing the subdomain
    local stripped_domain=$(echo "$full_domain" | sed -E 's/^[^.]*\.//')
    echo "$stripped_domain"
}