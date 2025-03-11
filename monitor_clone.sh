#!/bin/bash

source ".env"

echo "Waiting for the cloning process to complete..."
while true; do
    CLONE_STATUS=$(
        MYSQL_PWD="$RECIPIENT_ADMIN_PASS" \
        mysql -u"$RECIPIENT_ADMIN_USER" -N -s \
        -e "SELECT STATE FROM performance_schema.clone_status"
    )

    if [[ "$CLONE_STATUS" == "Completed" ]]; then
        echo "Cloning completed successfully."
        break
    elif [[ "$CLONE_STATUS" == "Failed" ]]; then
        echo "Cloning process failed. Exiting."
        exit 1
    fi

    echo "Cloning in progress... (STATE: $CLONE_STATUS)"
    sleep 5
done
