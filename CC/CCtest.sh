#!/bin/bash

FILE=/home/automate/.ssh/authorized_keys     
if [ -f $FILE ]; then
   echo "File $FILE exists."
else
   echo "File $FILE does not exist."
fi
