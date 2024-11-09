#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  ATOMIC_NUMBER_TEST=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1;")
  ATOMIC_SYMBOL_TEST=$($PSQL "SELECT * FROM elements WHERE symbol='$1';")
  ATOMIC_NAME_TEST=$($PSQL "SELECT * FROM elements WHERE name='$1';")

  if [[ -z $ATOMIC_NUMBER_TEST && -z $ATOMIC_SYMBOL_TEST && -z $ATOMIC_NAME_TEST ]]
  then
    echo "I could not find that element in the database."
  else
    if [[ ! -z $ATOMIC_NUMBER_TEST ]]
    then
      IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME <<< $ATOMIC_NUMBER_TEST
    elif [[ ! -z $ATOMIC_SYMBOL_TEST ]]
    then
      IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME <<< $ATOMIC_SYMBOL_TEST
    elif [[ ! -z $ATOMIC_NAME_TEST ]]
    then
      IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME <<< $ATOMIC_NAME_TEST
    fi
    ATOMIC_DATA=$($PSQL "SELECT type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties LEFT JOIN types ON properties.type_id=types.type_id WHERE atomic_number=$ATOMIC_NUMBER")
    IFS='|' read -r TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< $ATOMIC_DATA
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi