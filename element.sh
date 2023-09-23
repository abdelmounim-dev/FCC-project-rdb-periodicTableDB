#!/bin/bash
#program that gets information about an element given as an argument

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
  exit 0
else 

    # Check if the input is a positive integer for atomic number
  if [[ $1 =~ ^[1-9][0-9]*$ ]]; then
      ATOMIC_NUMBER=$1
      ATOM_RESULT=$($PSQL "select name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius\
        from elements inner join properties using (atomic_number)\
        inner join types using(type_id)\
        where atomic_number = $ATOMIC_NUMBER")

      if [[ -z $ATOM_RESULT ]] 
      then 
        echo I could not find that element in the database.
        exit 0
      else 
      echo "$ATOM_RESULT" | while read NAME bar SYMBOL bar TYPE bar MASS bar MELTING bar BOILING
      do 
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        done
      fi 
  
  elif [[ $1 =~ ^[A-Za-z]{1,2}$ ]]; then
    SYMBOL=$1
    ATOM_RESULT=$($PSQL "select name, atomic_number, type, atomic_mass,\
        melting_point_celsius, boiling_point_celsius\
        from elements inner join properties using (atomic_number)\
        inner join types using(type_id)\
        where elements.symbol = '$SYMBOL'")
      if [[ -z $ATOM_RESULT ]] 
      then 
        echo I could not find that element in the database.
        exit 0
      else 
      echo "$ATOM_RESULT" | while read NAME bar ATOMIC_NUMBER bar TYPE bar MASS bar MELTING bar BOILING
      do 
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        done
      fi 

    elif [[ $1 =~ ^[A-Za-z]+$ ]]; then
      NAME=$1
      ATOM_RESULT=$($PSQL "select symbol, atomic_number, type, atomic_mass,\
        melting_point_celsius, boiling_point_celsius\
        from elements inner join properties using (atomic_number)\
        inner join types using(type_id)\
        where elements.name = '$NAME'")
      if [[ -z $ATOM_RESULT ]] 
      then 
        echo I could not find that element in the database.
        exit 0
      else 
      echo "$ATOM_RESULT" | while read SYMBOL bar ATOMIC_NUMBER bar TYPE bar MASS bar MELTING bar BOILING
      do 
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        done
      fi 
  fi
  # Check if the input is an atomic symbol with exactly 2 characters
fi
