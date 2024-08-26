#!/bin/bash

# Define the source path of the file to copy.
# This path is pointing to the existing file which is required to copy.
SOURCE_FILE="/Users/arunkumar/myagent/myagent_work/1/test-results/test_unit_results.trx"

# Define the destination directory where the file will be copied to.
# Ensure this directory exists or will be created by the script.
DEST_DIR="/Users/arunkumar/Documents/VisualStudio/sample-unit-testing-using-dotnet-test-1/Test-Results"

# Get the current date and time in YYYY-MM-DD_HH-MM-SS format.
# This timestamp will be appended to the filename to ensure uniqueness.
CURRENT_DATETIME=$(date +"%Y-%m-%d_%H-%M-%S")

# Define the destination file path with the current date and time appended.
# This helps to keep track of different versions of the file over time.
DEST_FILE="${DEST_DIR}/test_unit_results_${CURRENT_DATETIME}.trx"

# Check if the source file exists.
# If the source file does not exist, print an error message and exit.
if [ ! -f "$SOURCE_FILE" ]; then
  echo "Source file does not exist: $SOURCE_FILE"
  exit 1
fi

# Create the destination directory if it does not already exist.
# The -p flag ensures that no error is thrown if the directory already exists.
mkdir -p "$DEST_DIR"

# Copy the source file to the destination with the new name.
# This operation includes the current date and time in the new filename.
cp "$SOURCE_FILE" "$DEST_FILE"

# Check if the copy operation was successful.
# If successful, print a confirmation message. If not, print an error and exit.
if [ $? -eq 0 ]; then
  echo "File copied successfully to: $DEST_FILE"
else
  echo "Failed to copy the file."
  exit 1
fi
