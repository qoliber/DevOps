#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $DIR/../wizard/steps/step.php.sh
source $DIR/../wizard/steps/step.php-version.sh
source $DIR/../wizard/steps/step.blackfire.sh
source $DIR/../wizard/steps/step.db.sh
source $DIR/../wizard/steps/step.http-server.sh
source $DIR/../wizard/steps/step.welcome.sh

DATABASE="MySQL Server 8.0"
PHP_VERSION="PHP 8.1"
HTTP_SERVER="Nginx"

function install_wizard() {
    step=1
    result=0

    while true; do
        case $step in
            1)
                welcome
                result=$?
                ;;
            2)
                select_php_version
                result=$?
                ;;
            3)
                install_blackfire
                result=$?
                ;;
            4)
                select_db_server
                result=$?
                ;;
            5)
                select_http_server
                result=$?
                ;;
            6)
                dialog --title "Step $step - Confirmation" --extra-button --extra-label "Previous" --ok-label "Finish" --cancel-label "Exit" \
                       --yesno "Finish and see the message?" 15 70
                result=$?
                ;;
        esac


        # Handle navigation and exit
        case $result in
            0) # OK/Next pressed
                if [ $step -eq 4 ]; then
                    clear
                    echo "Hurray"
                    break
                else
                    ((step++))
                fi
                ;;
            1) # Cancel/Exit pressed
                echo "Process exited."
                break
                ;;
            3) # Extra/Previous pressed
                if [ $step -gt 1 ]; then
                    ((step--))
                fi
                ;;
            255)
                echo "Dialog closed or ESC was pressed."
                break
                ;;
        esac
    done
}

# Run the dialog navigation function
install_wizard

clear
echo "Database: $DATABASE"

for choice in $PHP_VERSIONS
do
  echo "PHP: $choice"
done

echo "HTTP_SERVER: $HTTP_SERVER"

echo "installBlackfire: $installBlackfire"
echo "BLACKFIRE_CLIENT_ID=$BLACKFIRE_CLIENT_ID"
echo "BLACKFIRE_CLIENT_TOKEN=$BLACKFIRE_CLIENT_ID"
echo "BLACKFIRE_SERVER_ID=$BLACKFIRE_SERVER_ID"
echo "BLACKFIRE_SERVER_TOKEN=$BLACKFIRE_SERVER_TOKEN"