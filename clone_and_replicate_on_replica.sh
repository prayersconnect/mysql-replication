#!/bin/bash
set -e  # Exit on any error

echo "🚀 Starting MySQL replication setup process..."

# Run steps in sequence
./prepare_env.sh
./check_mysql_status.sh
./configure_primary.sh
./configure_replica.sh
./check_replication_user.sh
./configure_clone_donor.sh
./clone_database.sh
./monitor_clone.sh
./setup_replication.sh

echo "✅ MySQL replication setup completed successfully!"
