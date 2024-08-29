#!/bin/bash

# Navigate to the agent's directory
cd /Users/arunkumar/myagent || { echo "Directory not found!"; exit 1; }

# Run the run.sh script
./run.sh

# Optionally, check if the run.sh script was successful
if [ $? -eq 0 ]; then
  echo "Agent started successfully."
else
  echo "Failed to start the agent."
  exit 1
fi
