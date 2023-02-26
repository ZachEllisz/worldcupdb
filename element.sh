#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

function Element_Info() {
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  else
    if [[ ! $1 =~  ^[0-9]+$ ]]
    then
      if [[ $1 = [A-Z] ]]
      then
        GET_ELEMENT=$($PSQL "select atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type from properties join elements using(atomic_number) join types using(type_id) where elements.symbol like '$1'")
      else
        GET_ELEMENT=$($PSQL "select atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type from properties join elements using(atomic_number) join types using(type_id) where elements.name Ilike '$1%' order by name limit 1")
      fi   
    else
      GET_ELEMENT=$($PSQL "select atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type from properties join elements using(atomic_number) join types using(type_id) where elements.atomic_number=$1")
    fi
    if [[ -z $GET_ELEMENT ]]
    then
      echo "I could not find that element in the database."
    else
        echo "$GET_ELEMENT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE
        do
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
        done
    fi
  fi
}

Element_Info $1
