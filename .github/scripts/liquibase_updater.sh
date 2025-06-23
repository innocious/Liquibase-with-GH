#!/bin/bash

# A script to run Liquibase updates for a specific environment.
# It ensures the correct properties file is used.

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Argument validation ---
# Check if the environment argument is provided.
if [ -z "$1" ]; then
  echo "Error: Environment not specified. Usage: $0 <dev|uat|prod>"
  exit 1
fi

ENV=$1
echo "Starting Liquibase update for environment: ${ENV}"

# --- Set Directory ---
# Navigate to the database directory where all our liquibase files are.
# This makes file paths consistent for the liquibase command.
cd database

# --- Pre-run Checks ---
PROPERTIES_FILE="liquibase-${ENV}.properties"
if [ ! -f "$PROPERTIES_FILE" ]; then
    echo "Error: Properties file not found: ${PROPERTIES_FILE}"
    exit 1
fi
echo "Using properties file: ${PROPERTIES_FILE}"

# --- Run Liquibase ---
# This is the core command. It will be executed inside the liquibase/liquibase Docker container by our GitHub Action.
# --defaults-file specifies the connection details (H2 database URL, etc.).
# 'update' is the command to apply the schema changes from the changelog referenced inside the properties file.
liquibase --defaults-file=${PROPERTIES_FILE} update

echo "Liquibase update for environment '${ENV}' completed successfully."