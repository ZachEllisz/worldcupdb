#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
RANDOM_NUM=$(( $RANDOM % 1000 + 1 ))
function GUESS_NUMBER() {
  

  echo "Enter your username:" 
  read USERNAME
  
  PLAYER_NAME=$($PSQL "SELECT username FROM player WHERE username='$USERNAME'")
  if [[ -z $PLAYER_NAME ]]
  then
    INSERT_PLAYER_NAME=$($PSQL "INSERT INTO player(username) VALUES('$USERNAME')")
    PLAYER_BEST_GAME=$($PSQL "SELECT best_game FROM player WHERE username='$USERNAME'")
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    echo "Guess the secret number between 1 and 1000:"
  else
    PLAYER_GAMES_PLAYED=$($PSQL "SELECT games_played FROM player WHERE username='$PLAYER_NAME'")
    PLAYER_BEST_GAME=$($PSQL "SELECT best_game FROM player WHERE username='$PLAYER_NAME'")
    echo "Welcome back, $PLAYER_NAME! You have played $PLAYER_GAMES_PLAYED games, and your best game took $PLAYER_BEST_GAME guesses."
    echo "Guess the secret number between 1 and 1000:"
  fi
  read PLAYER_GUESS
  NUMBER_OF_GUESSES=1
  echo $RANDOM_NUM
  until [[ $PLAYER_GUESS = $RANDOM_NUM ]]
  do
    if [[ ! $PLAYER_GUESS =~ ^[0-9]+$ ]]
    then
      echo "That is not an integer, guess again:"
      read PLAYER_GUESS
      let "NUMBER_OF_GUESSES+=1"
      echo $NUMBER_OF_GUESSES
    else
      if [[ $PLAYER_GUESS < $RANDOM_NUM ]]
      then
        echo "It's lower than that, guess again:"
        read PLAYER_GUESS
        let "NUMBER_OF_GUESSES+=1"
        echo $NUMBER_OF_GUESSES
      else
        echo "It's higher than that, guess again:"
        read PLAYER_GUESS
        let "NUMBER_OF_GUESSES+=1"
        echo $NUMBER_OF_GUESSES
      fi
    fi
  done
  UPDATE_NUMBER_OF_GAMES=$($PSQL "UPDATE player set games_played = games_played + 1 WHERE username = '$PLAYER_NAME' or username = '$USERNAME'")
  if [[ $NUMBER_OF_GUESSES < $PLAYER_BEST_GAME  ]]
  then
    UPDATE_BEST_GAME=$($PSQL "UPDATE player SET best_game = $NUMBER_OF_GUESSES WHERE username ='$PLAYER_NAME' or username = '$USERNAME'")
  else
    if [[ $PLAYER_BEST_GAME = 0 ]]
    then
      UPDATE_BEST_GAME=$($PSQL "UPDATE player SET best_game = $NUMBER_OF_GUESSES WHERE username ='$PLAYER_NAME' or username = '$USERNAME'")
    fi
  fi
  echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $RANDOM_NUM. Nice job!"
}
GUESS_NUMBER