#!/usr/bin/env bash

extract_version() {
    local input_string="$1"
    if [[ $input_string =~ [0-9]+(\.[0-9]+)? ]]; then
        echo "${BASH_REMATCH[0]}"
        return 0  # Success
    else
        echo "No version number found."
        return 1  # Failure
    fi
}