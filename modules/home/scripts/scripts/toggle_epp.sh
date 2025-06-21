#!/usr/bin/env bash

# Target preference values
LOW="power"
HIGH="balance_performance"

# Path to EPP value (assumes symmetric values across cores)
EPP_PATH="/sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference"

# Get current value
CURRENT=$(cat "$EPP_PATH")

# Determine new value
if [[ "$CURRENT" == "$LOW" ]]; then
  NEW="$HIGH"
else
  NEW="$LOW"
fi

# Apply to all cores
for EPP in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
  echo "$NEW" | sudo tee "$EPP" > /dev/null
done

# Print status for Waybar
echo "$NEW"
