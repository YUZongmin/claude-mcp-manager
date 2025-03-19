# Claude MCP Profile Manager

A shell script to manage Claude Desktop's MCP (Model Control Protocol) profiles. This tool allows you to easily switch between different MCP configurations for Claude Desktop.

## Features

- List available MCP profiles
- Switch between different MCP profiles
- Save current configuration as a new profile
- Disable MCP configuration
- Check current MCP status
- Automatic profile directory creation

## Prerequisites

- macOS (tested on macOS 14.0+)
- Claude Desktop installed
- Zsh shell

## Installation

1. Clone this repository:

```bash
git clone https://github.com/yourusername/claude-mcp-manager.git
cd claude-mcp-manager
```

2. Create a `.env` file in the project root with your configuration:

```bash
# Claude Desktop Configuration Path
CLAUDE_CONFIG="/path/to/your/claude_desktop_config.json"

# Profiles Directory Path
PROFILES_DIR="/path/to/your/profiles/directory"
```

3. Make the script executable:

```bash
chmod +x mcp.sh
```

4. Add the script to your `.zshrc`:

```bash
source "/path/to/claude-mcp-manager/mcp.sh"
```

5. Reload your shell configuration:

```bash
source ~/.zshrc
```

## Usage

The script provides the following commands:

```bash
mcp ls         # List all available profiles
mcp status     # Show current MCP configuration status
mcp off        # Disable MCP configuration
mcp save NAME  # Save current configuration as a new profile
mcp PROFILE    # Switch to specified profile
```

### Example Usage

1. First, save your current Claude configuration as a profile:

```bash
mcp save default
```

2. List available profiles:

```bash
mcp ls
```

3. Switch between profiles:

```bash
mcp default
```

4. Check current status:

```bash
mcp status
```

## Directory Structure

```
claude-mcp-manager/
├── mcp.sh           # Main script file
├── .env             # Configuration file (create this)
├── .gitignore       # Git ignore file
├── README.md        # This file
└── profiles/        # Directory for storing profiles (created automatically)
```

## Configuration

### Environment Variables

Create a `.env` file in the project root with the following variables:

- `CLAUDE_CONFIG`: Path to your Claude Desktop configuration file
- `PROFILES_DIR`: Path to the directory where you want to store your MCP profiles

### Profile Format

Profiles are stored as JSON files in the `profiles/` directory. Each profile should follow the Claude Desktop configuration format:

```json
{
  "globalShortcut": "Control+Option+Space",
  "mcpServers": {
    // Your MCP server configurations here
  }
}
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Claude Desktop team for the MCP feature
- The open-source community for inspiration and tools
