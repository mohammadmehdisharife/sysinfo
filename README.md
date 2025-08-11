# System Info Script

A lightweight Bash script that gathers and displays key system information such as:

- Current user and hostname  
- Operating System and architecture  
- Host product name and version  
- Kernel version  
- System uptime  
- Number of installed packages (Pacman-based systems) and branch  
- Default shell and its version  
- CPU model, core count, and frequency  
- GPU information  
- WiFi adapter details  
- System locale

## Requirements

- Bash shell  
- `lspci` command (for GPU and network adapter info)  
- Pacman package manager (optional, for package count)  
- Access to `/sys/class/dmi/id/` and `/proc/cpuinfo`

## Usage

Make the script executable and run it:

```bash
chmod +x system-info.sh
./system-info.sh
```

## Notes

The script checks for the presence of certain commands and files, and falls back gracefully if they are not available.

Designed primarily for Arch Linux and similar systems using Pacman, but many parts are portable to other Linux distros

## License
MIT License