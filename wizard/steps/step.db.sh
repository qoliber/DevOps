#!/usr/bin/env bash

# Present the radiolist dialog to the user
select_db_server() {
  # Initialize options as off
  MYSQL_OPTION="off"
  MARIADB_OPTION="off"
  SKIP_DB="off"

  # Set the correct option to "on" based on MYSQL_SERVER
  if [ "$DATABASE" = "MySQL Server 8.0" ]; then
      MYSQL_OPTION="on"
  elif [ "$DATABASE" = "MariaDB Latest Version" ]; then
      MARIADB_OPTION="on"
  elif [ "$DATABASE" = "skip" ]; then
      SKIP_DB="on"
  fi

  dialog \
    --title "Step $step - Database Server" \
    --extra-button --extra-label "Previous" \
    --ok-label "Next" \
    --cancel-label "Exit" \
    --radiolist "" 8 60 4 \
  "mysql8" "" $MYSQL_OPTION \
  "mariadb" "" $MARIADB_OPTION 2>db.txt

  # Read the selected option from title.txt
  local result=$?
  DATABASE=$(<db.txt)

  # Clean up by removing the temporary file
  rm db.txt

  return $result
}