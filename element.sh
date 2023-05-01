#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
  exit
fi

ELEMENT_INFO=$($PSQL "select atomic_number,atomic_mass,melting_point_celsius,boiling_point_celsius,symbol,name,type from properties inner join elements using(atomic_number) inner join types using(type_id) where atomic_number=$(( $1 )) or symbol='$1' or name='$1'")
if [[ -z $ELEMENT_INFO ]]
then
  echo -e "I could not find that element in the database."
else
  echo "$ELEMENT_INFO" | sed 's/|/ /g' | while read ATOMIC_NUMBER MASS MELTING_POINT BOILING_POINT SYMBOL NAME TYPE
  do
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
fi
