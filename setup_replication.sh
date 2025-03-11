#!/bin/bash

source ".env"

echo "Configuring replication on recipient using automatic positioning..."
MYSQL_PWD="$RECIPIENT_ADMIN_PASS" mysql -u"$RECIPIENT_ADMIN_USER" <<EOF
STOP REPLICA;
RESET REPLICA ALL;

CHANGE REPLICATION SOURCE TO
    SOURCE_HOST = '${DONOR_HOST}',
    SOURCE_USER = '${REPL_USER}',
    SOURCE_PASSWORD = '${REPL_PASS}',
    SOURCE_AUTO_POSITION=1;

START REPLICA;
SHOW REPLICA STATUS\G;
EOF

if [[ $? -ne 0 ]]; then
    echo "Failed to configure replication. Exiting."
    exit 1
fi

echo "Replication setup completed successfully using GTID."
