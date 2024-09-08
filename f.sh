#!/bin/bash

# Threshold for sudo attempts
THRESHOLD=3

# The log file which has sudo access logs
LOG_FILE="/var/log/sudo-access.log"

# Which email to be sent to 
ADMIN_EMAIL="mm23122004@gmail.com"

# Get low privileged users 
LOW_PREV_USERS=$(awk -F: '$3 >= 1000 && $3 != 65534 {print $1}' /etc/passwd)

echo "$LOW_PREV_USERS"

# To go through all low privileged users
for USER in $LOW_PREV_USERS; do 
  # Count sudo attempts
  SUDO_COUNT=$(grep -c "$USER : user NOT in sudoers" $LOG_FILE)

  # Check if attempts exceed Threshold
  if [ $SUDO_COUNT > $THRESHOLD ]; then
  
    # Send mail to ADMIN_EMAIL
    echo "Threshold reached. Mailing about $USER"
    SUBJECT="Excessive sudo attempts by $USER"
    BODY="$USER tried to attempt sudo access $SUDO_COUNT times."
    
    # Use echo and mail to send the email
    echo "$BODY" | mail -s "$SUBJECT" "$ADMIN_EMAIL"
  fi
done
