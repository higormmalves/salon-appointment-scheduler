#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo "Welcome to My Salon, how can I help you?"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  echo "6) exit"

  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) SERVICE_MENU $SERVICE_ID_SELECTED;;
    2) SERVICE_MENU $SERVICE_ID_SELECTED;;
    3) SERVICE_MENU $SERVICE_ID_SELECTED;;
    4) SERVICE_MENU $SERVICE_ID_SELECTED;;
    5) SERVICE_MENU $SERVICE_ID_SELECTED;;
    6) EXIT ;;
    *) MAIN_MENU "I could not find that service. What would you like today?";;
  esac
}

SERVICE_MENU() {
  SERVICE_ID=$1

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi

  
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed 's/ |/"/')
  echo -e "\nWhat time would you like your appointment, $CUSTOMER_NAME_FORMATTED?"
  read SERVICE_TIME

  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")
  
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID")
  SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/ |/"/')
  echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME_FORMATTED."
}

EXIT() {
  echo -e "\nThank you for visiting us.\n"
}

MAIN_MENU