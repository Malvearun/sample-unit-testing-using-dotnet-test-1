#!/bin/bash

# Step 1: Navigate to the SonarQube directory
cd //usr/local/sonarqube/bin/macosx-universal-64 || { echo "Error: Failed at Step 1 (Directory not found)"; exit 1; }

# Step 2: Start SonarQube
./sonar.sh start
if [ $? -ne 0 ]; then
    echo "Error: Failed at Step 2 (Could not start SonarQube)"
    exit 2
fi

# Step 3: Wait a few seconds to ensure SonarQube has time to start
sleep 40

# Step 4: Check the status of SonarQube
./sonar.sh status | grep -q "SonarQube is running"
if [ $? -ne 0 ]; then
    echo "Error: Failed at Step 4 (SonarQube is not running)"
    exit 4
fi

# Step 5: Open Firefox and navigate to the SonarQube login page
open -a "Firefox" http://localhost:9002/
if [ $? -ne 0 ]; then
    echo "Error: Failed at Step 5 (Could not open Firefox)"
    exit 5
fi

# Step 6: Wait for the SonarQube login page to load fully
echo "Waiting for the SonarQube login page to load..."
attempts=0
max_attempts=20  # Timeout after 30 seconds (20*2 seconds)

while ! curl -s http://localhost:9002/api/system/status | grep -q '"status":"UP"'; do
    sleep 5
    attempts=$((attempts+1))
    if [ $attempts -ge $max_attempts ]; then
        echo "Error: Failed at Step 6 (Login page did not load within the expected time)"
        exit 6
    fi
done
sleep 5  # Additional wait time to ensure the page is fully loaded

# Automate login using `cliclick`
cliclick "kp:tab" "kp:tab" "kp:tab" "kp:enter"
if [ $? -ne 0 ]; then
    echo "Error: Failed at Step 6 (Login automation failed)"
    exit 6
fi

# Step 7: Wait for the projects page to load fully
sleep 5  # Wait for login to complete

# Check if login was successful by verifying the page content
curl -s http://localhost:9002/projects | grep -q "Projects"
if [ $? -ne 0 ]; then
    echo "Error: Failed at Step 7 (Projects page did not load correctly)"
    exit 7
fi

# Open the projects page in Firefox
open -a "Firefox" http://localhost:9002/projects
if [ $? -ne 0 ]; then
    echo "Error: Failed at Step 7 (Could not open projects page)"
    exit 7
fi

echo "SonarQube should now be running and the projects page is open in Firefox."
