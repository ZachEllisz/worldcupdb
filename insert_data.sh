#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  TEAMS1_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  if [[ $WINNER != "winner" ]]
  then
    if [[ -z $TEAMS1_ID ]]
    then
      # insert teams
      INSERT_TEAMS1_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAMS1_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into name, $WINNER
      fi
    fi
    
    TEAMS2_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ $OPPONENT != "opponent" ]]
    then
      if [[ -z $TEAMS2_ID ]]
      then
        # insert teams
        INSERT_TEAMS2_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $INSERT_TEAMS2_RESULT == "INSERT 0 1" ]]
        then
          echo Inserted into name, $OPPONENT
        fi
      fi
    fi
  fi

  TEAM_ID_1=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  TEAM_ID_2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  if [[ -n $TEAM_ID_1 || -n $TEAM_ID_2 ]]
  then
    if [[ $YEAR != "year" ]]
    then
      INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID_1, $TEAM_ID_2, $WINNER_GOALS, $OPPONENT_GOALS)")
      if [[ $INSERT_GAMES == "INSERT 0 1" ]]
      then
        echo Inserted into games, $YEAR $ROUND $WINNER_GOALS $OPPONENT_GOALS
      fi
    fi
  fi
done
