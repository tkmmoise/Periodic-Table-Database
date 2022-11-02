#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
  USER_ENTRY=$1 

  # If USER_ENTRY is number
  if [[ $USER_ENTRY =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number = '$USER_ENTRY'")
  else
    ELEMENT=$($PSQL "SELECT * FROM elements WHERE symbol = '$USER_ENTRY' or name = '$USER_ENTRY'")
  fi

  # If ELEMENT is retrieve
  if [[ $ELEMENT ]]
  then
    echo $ELEMENT | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME
    do
    # get ELEMENT PROPERTIES by atomic number
      PROPERTIES=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM properties JOIN types USING(type_id) WHERE atomic_number= '$ATOMIC_NUMBER'")
      echo $PROPERTIES | while read ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    done
    
  else
    echo "I could not find that element in the database."
  fi

else
  echo "Please provide an element as an argument."
fi
