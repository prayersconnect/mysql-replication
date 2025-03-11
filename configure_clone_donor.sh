#!/bin/bash

source ".env"

echo "Adding donor '${DONOR_HOST}' to the recipient's clone_valid_donor_list..."
MYSQL_PWD="$RECIPIENT_ADMIN_PASS" mysql -u"$RECIPIENT_ADMIN_USER" <<EOF
SET GLOBAL clone_valid_donor_list = '${DONOR_HOST}:3306';
EOF

if [[ $? -ne 0 ]]; then
    echo "Failed to set clone_valid_donor_list. Exiting."
    exit 1
fi

echo "Donor added to clone_valid_donor_list successfully."
