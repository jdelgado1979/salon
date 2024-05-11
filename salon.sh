#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"

 echo -e "\nWelcome to My Salon, how can I help you?\n"

SELECT_SERVICE() {

 if [[ $1 ]]

  then

    echo -e "\n$1"

  fi
 
   # get services
   
   AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services")
   echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME

    do

      echo "$SERVICE_ID) $SERVICE_NAME"

    done
        
    read SERVICE_ID_SELECTED

    
    # if input is not a number
    if [[ ! $SERVICE_ID_SELECTED =~ ^[1-5]+$ ]]

    then

     SELECT_SERVICE "I could not find that service. What would you like today?" 

     else

       #get customer info

      echo -e "\nWhat's your phone number?"

      read CUSTOMER_PHONE

      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

       #if customer doesn't exist

      if [[ -z $CUSTOMER_NAME ]]

      then

      #get new customer name

      echo -e "\nI don't have a record for that phone number, what's your name?"

      read CUSTOMER_NAME 

      #insert new customer

      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")

      fi

      #get the time for the appointment
      SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
      SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/ |/"/')
      echo -e "\nWhat time would you like your $SERVICE_NAME_FORMATTED, $CUSTOMER_NAME?"

      read SERVICE_TIME 

       # get customer_id

      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      

      # insert appointment
      CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed 's/ |/"/')
      INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
      echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME_FORMATTED."
     
    fi

}

 
SELECT_SERVICE
