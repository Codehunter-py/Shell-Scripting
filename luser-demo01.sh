#!/bin/bash

echo 'Hello'
WORD='script'

echo "$WORD"

echo '$WORD'

echo "This is shell $WORD"

#Append text to variable
echo "${WORD}ing is fun!"

#Show how not append text to variable
echo "$WORDing is fun!"

#Create a new variable
ENDING='ed'

#combine the 2 variables
echo "This is ${WORD}${ENDING}"

#change the value stored in the ENDING variable
ENDING='ing'
echo "${WORD}${ENDING}"

#Reassing
ENDING='s'
echo "${WORD}${ENDING}"

