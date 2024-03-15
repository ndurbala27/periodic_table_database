#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]] 
  then
    echo "Please provide an element as an argument."
  else
    ELEM=$1
fi

if ! [[ -z $ELEM ]]
  then
    PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"
    NUMLIST=($($PSQL "SELECT atomic_number FROM elements;"))
    SYMBLIST=($($PSQL "SELECT symbol FROM elements;"))
    NAMELIST=($($PSQL "SELECT name FROM elements;"))

  if [[ ${NUMLIST[*]} =~ $ELEM ]]
    then 
        ATOMNUM=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number='$ELEM';")
  elif [[ ${SYMBLIST[*]} =~ $ELEM ]]
    then
        ATOMNUM=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ELEM';")
  else [[ ${NAMELIST[*]} =~ $ELEM ]]
        ATOMNUM=$($PSQL "SELECT atomic_number FROM elements WHERE name='$ELEM';")
  fi

    if ! [[ -z $ATOMNUM ]]
      then
        NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMNUM;")
        SYM=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMNUM;")
        TYPE=$($PSQL "SELECT type FROM types full join properties on types.type_id = properties.type_id WHERE atomic_number=$ATOMNUM;")
        MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMNUM;")
        MP=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMNUM;")
        BP=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMNUM;")
        SYMF="$(echo $SYM | sed 's/ *$//')"

        echo -e "The element with atomic number"$ATOMNUM" is"$NAME" ("$SYMF"). It's a"$TYPE", with a mass of"$MASS" amu."$NAME" has a melting point of"$MP" celsius and a boiling point of"$BP" celsius."
      else 
      echo "I could not find that element in the database."
    fi
  fi