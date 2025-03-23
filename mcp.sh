#!/bin/zsh

# Load environment variables from .env file
if [ -f "$(dirname "$0")/.env" ]; then
    source "$(dirname "$0")/.env"
else
    echo "Error: .env file not found. Please create one with CLAUDE_CONFIG and PROFILES_DIR variables."
    return 1
fi

# Function to restart Claude app
restart_claude() {
    echo "Restarting Claude..."
    # Close Claude if it's running
    osascript -e 'tell application "Claude" to quit'
    # Wait a moment for the app to close properly
    sleep 2
    # Open Claude
    open -a "Claude"
    echo "Claude has been restarted!"
}

# Claude MCP profile management function
mcp() {
  local claude_config="${CLAUDE_CONFIG}"
  local profiles_dir="${PROFILES_DIR}"
  local empty_config='{
  "mcpServers": {
  }
}'

  # Create profiles directory if it doesn't exist
  if [[ ! -d "$profiles_dir" ]]; then
    mkdir -p "$profiles_dir"
    echo "Created profiles directory at: $profiles_dir"
  fi

  # Get available profiles dynamically
  local available_profiles=()
  if [[ -d "$profiles_dir" ]]; then
    for profile_file in "$profiles_dir"/*.json; do
      if [[ -f "$profile_file" ]]; then
        local profile_name=$(basename "$profile_file" .json)
        available_profiles+=("$profile_name")
      fi
    done
  fi
  
  # Handle different commands
  if [[ "$1" == "off" ]]; then
    echo "$empty_config" > "$claude_config"
    echo "Claude MCP configuration disabled."
    restart_claude
  
  elif [[ "$1" == "status" ]]; then
    if [[ -f "$claude_config" ]]; then
      echo "Claude MCP configuration status:"
      local server_count=$(grep -o '"command":' "$claude_config" | wc -l | tr -d ' ')
      echo "- $server_count MCP servers configured"
      
      # Try to determine which profile is active
      local matched=0
      for profile in "${available_profiles[@]}"; do
        if cmp -s "$claude_config" "$profiles_dir/$profile.json"; then
          echo "- Active profile: $profile"
          matched=1
          break
        fi
      done
      
      if [[ $matched -eq 0 ]]; then
        if [[ $server_count -eq 0 ]]; then
          echo "- MCP is disabled (no servers)"
        else
          echo "- Custom configuration (not matching any profile)"
        fi
      fi
    else
      echo "Claude config file not found at $claude_config"
    fi
  
  elif [[ "$1" == "ls" ]]; then
    echo "Available MCP profiles:"
    if [[ ${#available_profiles[@]} -eq 0 ]]; then
      echo "No profiles found. Use 'mcp save NAME' to create a new profile."
    else
      for profile in "${available_profiles[@]}"; do
        local server_count=$(grep -o '"command":' "$profiles_dir/$profile.json" | wc -l | tr -d ' ')
        echo "- $profile ($server_count servers)"
      done
    fi
  
  elif [[ "$1" == "save" && -n "$2" ]]; then
    if [[ -f "$claude_config" ]]; then
      cp "$claude_config" "$profiles_dir/$2.json"
      echo "Current configuration saved as profile '$2'"
    else
      echo "Error: Claude config file not found at $claude_config"
      return 1
    fi
  
  elif [[ -f "$profiles_dir/$1.json" ]]; then
    cp "$profiles_dir/$1.json" "$claude_config"
    echo "Claude MCP configuration set to '$1' profile."
    restart_claude
  
  else
    echo "Usage: mcp [command|profile]"
    echo "Commands:"
    echo "  off        - Disable MCP and restart Claude"
    echo "  status     - Show current MCP status"
    echo "  ls         - List available profiles"
    echo "  save NAME  - Save current configuration as a new profile"
    echo "Available profiles: ${available_profiles[@]}"
    return 1
  fi
} 