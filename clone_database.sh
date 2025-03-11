#!/bin/bash

source ".env"

echo "Cloning database from donor..."
MYSQL_PWD="$RECIPIENT_ADMIN_PASS" mysql -u"$RECIPIENT_ADMIN_USER" <<EOF
CLONE INSTANCE FROM '${REPL_USER}'@'${DONOR_HOST}':3306 IDENTIFIED BY '${REPL_PASS}';
EOF

if [[ $? -ne 0 ]]; then
    echo "Clone command failed. Exiting."
    exit 1
fi

echo "Clone initiated successfully."
