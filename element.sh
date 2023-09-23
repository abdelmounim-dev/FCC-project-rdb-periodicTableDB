#!/bin/bash
# Program that gets information about an element given as an argument

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

query_element_info() {
  local query="$1"
  local message="$2"

  local result="$($PSQL "$query")"

  if [[ -z $result ]]; then
    echo "I could not find that element in the database."
    exit 0
  else
    echo "$result" | (
      read ATOMIC_NUMBER bar NAME bar SYMBOL bar TYPE bar MASS bar MELTING bar BOILING
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    )
  fi
}

if [[ $1 =~ ^[1-9][0-9]*$ ]]; then
  ATOMIC_NUMBER=$1
  query_element_info \
    "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
     FROM elements
     INNER JOIN properties USING (atomic_number)
     INNER JOIN types USING (type_id)
     WHERE atomic_number = $ATOMIC_NUMBER"

elif [[ $1 =~ ^[A-Za-z]{1,2}$ ]]; then
  SYMBOL=$1
  query_element_info \
    "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
     FROM elements
     INNER JOIN properties USING (atomic_number)
     INNER JOIN types USING (type_id)
     WHERE elements.symbol = '$SYMBOL'"

elif [[ $1 =~ ^[A-Za-z]+$ ]]; then
  NAME=$1
  query_element_info \
    "SELECT atomic_number, name, symbol,  type, atomic_mass, melting_point_celsius, boiling_point_celsius
     FROM elements
     INNER JOIN properties USING (atomic_number)
     INNER JOIN types USING (type_id)
     WHERE elements.name = '$NAME'"
fi
