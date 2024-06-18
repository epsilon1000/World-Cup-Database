#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games;")

# Unique teams
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
        if [[ $WINNER != "winner" ]];
        then
                #Get team_id Winner
                TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

                #If not found
                if [[ -z $TEAM_ID_WINNER  ]]
                then
                        #Insert team_id winner
                        INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
                        if [[ $INSERT_WINNER == "INSERT 0 1" ]]
                        then
                                echo Inserted into teams, $WINNER
                        fi

                        #get new team_id
                        TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

                fi

                #Get team_id opponent *
                TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

                #If not found
                if [[ -z $TEAM_ID_OPPONENT  ]]
                then
                        #Insert team_id
                        INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
                        if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
                        then
                                echo Inserted into teams, $OPPONENT
                        fi

                        #get new team_id
                        TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
                fi
        
                #Insert into games table
                INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID_WINNER, $TEAM_ID_OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS) ")
                if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
                then
                        echo Inserted into games, $YEAR, $ROUND, $TEAM_ID_WINNER, $TEAM_ID_OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS
                fi

        fi
done
