#!/bin/bash

# Function to check if all services are active
check_services() {
  # Check process status
  echo "Checking running processes..."
  ps aux | grep '[o]pen5gs'
  echo

  # Check systemd service status
  echo "Checking systemd service status..."
  services_status=$(sudo systemctl is-active open5gs-* 2>&1)
  echo "$services_status"
  echo

  # Check if services are listed as active
  echo "Listing systemd units..."
  units_status=$(sudo systemctl list-units --all --plain --no-pager | grep 'open5gs-' 2>&1)
  echo "$units_status"
  echo

  # Check if services are enabled
  echo "Checking if services are enabled..."
  unit_files_status=$(systemctl list-unit-files | grep open5gs 2>&1)
  echo "$unit_files_status"
  echo
}

# Run the service checks
check_services

# Check if all services are active
if [[ "$(sudo systemctl is-active open5gs-*)" == *"active"* ]]; then
  echo "All CapXCore services are running."
else
  echo "Some CapXCore services are not running."
fi
