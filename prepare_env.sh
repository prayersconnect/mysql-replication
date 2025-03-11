#!/bin/bash

# Load credentials
if [[ -f ".env" ]]; then
    source ".env"
else
    echo "Credential file .env not found! Exiting."
    exit 1
fi

# Ensure required variables are set
if [[ -z "$RECIPIENT_ADMIN_USER" || -z "$RECIPIENT_ADMIN_PASS" || \
      -z "$DONOR_HOST" || -z "$REPL_USER" || -z "$REPL_PASS" || \
      -z "$RECIPIENT_HOST" ]]; then
    echo "Error: Missing one or more required environment variables. Check .env."
    exit 1
fi

echo "Environment variables loaded successfully."
