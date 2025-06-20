# Essential Linux Commands for Docker

This guide covers essential Linux commands that will help you navigate and work effectively during the Docker course. Even if you're new to Linux, these commands will get you up and running quickly.

## Directory Navigation

### Basic Navigation Commands

```bash
# Show current directory path
pwd

# List files and directories
ls                    # Basic listing
ls -l                 # Detailed listing with permissions, size, date
ls -la                # Include hidden files (starting with .)
ls -lh                # Human-readable file sizes

# Change directories
cd /path/to/directory # Go to specific directory
cd ~                  # Go to home directory
cd ..                 # Go up one directory level
cd -                  # Go back to previous directory
cd                    # Go to home directory (same as cd ~)
```

### Directory Operations

```bash
# Create directories
mkdir my-directory           # Create single directory
mkdir -p path/to/directory   # Create directory tree (with parent directories)

# Remove directories
rmdir empty-directory        # Remove empty directory
rm -rf directory-name        # Remove directory and all contents (be careful!)
```

## File Operations

### Creating Files

```bash
# Create empty files
touch filename.txt           # Create empty file or update timestamp
touch file1.txt file2.txt    # Create multiple files

# Create files with content
echo "Hello World" > file.txt              # Create file with content (overwrites)
echo "Additional line" >> file.txt         # Append to existing file
```

### Viewing File Contents

```bash
# View entire file
cat filename.txt             # Display entire file content
less filename.txt            # View file page by page (press 'q' to quit)
more filename.txt            # Similar to less (older version)

# View parts of files
head filename.txt            # Show first 10 lines
head -n 5 filename.txt       # Show first 5 lines
tail filename.txt            # Show last 10 lines
tail -n 5 filename.txt       # Show last 5 lines
tail -f logfile.txt          # Follow file changes (useful for logs)
```

### Copying and Moving Files

```bash
# Copy files
cp source.txt destination.txt              # Copy file
cp source.txt /path/to/destination/        # Copy to directory
cp -r source-directory/ destination/       # Copy directory recursively

# Move/rename files
mv oldname.txt newname.txt                 # Rename file
mv file.txt /path/to/destination/          # Move file to directory
mv directory/ /path/to/new/location/       # Move directory
```

### Deleting Files

```bash
# Delete files
rm filename.txt              # Delete single file
rm file1.txt file2.txt       # Delete multiple files
rm -i filename.txt           # Interactive deletion (asks for confirmation)
rm -f filename.txt           # Force deletion (no confirmation)
```

## Text Editing

### Using nano (Beginner-friendly editor)

```bash
# Open file in nano
nano filename.txt

# Nano shortcuts (shown at bottom of editor):
# Ctrl+X : Exit
# Ctrl+O : Save (Write Out)
# Ctrl+K : Cut line
# Ctrl+U : Paste
# Ctrl+W : Search
```

### Using vi/vim (Advanced editor)

```bash
# Open file in vi
vi filename.txt

# Basic vi commands:
# i        : Enter insert mode
# Esc      : Exit insert mode
# :w       : Save file
# :q       : Quit
# :wq      : Save and quit
# :q!      : Quit without saving
# dd       : Delete current line
# /search  : Search for text
```

## File Permissions and Ownership

### Understanding Permissions

```bash
# View permissions
ls -l filename.txt
# Output example: -rw-r--r-- 1 user group 1024 Jan 1 12:00 filename.txt
#                  ^^^^^^^^^ 
#                  Permission bits: user|group|others (read|write|execute)

# Change permissions
chmod 755 filename.txt       # rwxr-xr-x (owner: rwx, group: rx, others: rx)
chmod +x script.sh           # Add execute permission
chmod -w filename.txt        # Remove write permission
chmod u+w filename.txt       # Add write permission for user
```

### Ownership

```bash
# Change ownership (requires sudo for files you don't own)
sudo chown user:group filename.txt    # Change owner and group
sudo chown user filename.txt          # Change owner only
sudo chgrp group filename.txt         # Change group only
```

## Process Management

### Viewing Processes

```bash
# List running processes
ps                          # Show processes for current user
ps aux                      # Show all processes with details
top                         # Real-time process viewer (press 'q' to quit)
htop                        # Enhanced process viewer (if installed)

# Find specific processes
ps aux | grep docker        # Find processes containing "docker"
pgrep docker                # Get process IDs for docker processes
```

### Managing Processes

```bash
# Kill processes
kill 1234                   # Kill process with ID 1234
kill -9 1234                # Force kill process
killall process-name        # Kill all processes with given name
pkill process-name          # Kill processes by name pattern
```

## System Information

### System Details

```bash
# System information
uname -a                    # System information
whoami                      # Current username
id                          # User and group IDs
date                        # Current date and time
uptime                      # System uptime and load
df -h                       # Disk usage (human readable)
du -h                       # Directory size usage
free -h                     # Memory usage
```

### Network Information

```bash
# Network commands
ip addr show                # Show network interfaces
curl -I http://example.com  # Check if website is accessible
wget http://example.com/file.txt # Download file
ping google.com             # Test network connectivity
```

## Archive and Compression

### tar Archives

```bash
# Create archives
tar -czf archive.tar.gz directory/     # Create compressed archive
tar -cf archive.tar directory/         # Create uncompressed archive

# Extract archives
tar -xzf archive.tar.gz                # Extract compressed archive
tar -xf archive.tar                    # Extract uncompressed archive
tar -xzf archive.tar.gz -C /path/      # Extract to specific directory

# List archive contents
tar -tzf archive.tar.gz                # List files in compressed archive
```

## Text Processing

### Searching and Filtering

```bash
# Search within files
grep "search-term" filename.txt        # Search for text in file
grep -r "search-term" directory/       # Recursive search in directory
grep -i "search-term" filename.txt     # Case-insensitive search
grep -n "search-term" filename.txt     # Show line numbers

# Find files
find . -name "*.txt"                   # Find all .txt files
find . -type f -name "docker*"         # Find files starting with "docker"
find . -type d -name "logs"            # Find directories named "logs"
```

### Text Manipulation

```bash
# Sort and unique
sort filename.txt                      # Sort lines alphabetically
sort -n numbers.txt                    # Sort numerically
uniq filename.txt                      # Remove duplicate lines
sort filename.txt | uniq               # Sort and remove duplicates

# Count lines, words, characters
wc filename.txt                        # Count lines, words, characters
wc -l filename.txt                     # Count lines only
```

## Docker-Specific Useful Commands

### Environment and Logs

```bash
# View environment variables
env                                    # Show all environment variables
echo $PATH                             # Show specific environment variable

# Monitor logs (useful for Docker containers)
tail -f /var/log/syslog               # Follow system log
tail -f /var/log/docker.log           # Follow Docker log (if exists)

# Check available space (important for Docker images)
df -h                                  # Check disk space
docker system df                       # Check Docker disk usage
```

### File Permissions for Docker

```bash
# Common Docker-related permission commands
sudo usermod -aG docker $USER          # Add user to docker group
newgrp docker                          # Apply group changes without logout
sudo chmod 666 /var/run/docker.sock    # Fix Docker socket permissions (temporary)
```

## Tips for Docker Course

1. **Use Tab Completion**: Press Tab to auto-complete file and directory names
2. **Command History**: Use ↑ and ↓ arrows to navigate through command history
3. **Clear Screen**: Use `clear` or `Ctrl+L` to clear the terminal
4. **Stop Running Commands**: Use `Ctrl+C` to stop a running command
5. **Background Processes**: Add `&` at the end of a command to run it in background
6. **Multiple Commands**: Use `&&` to run commands sequentially: `cd mydir && ls`

## Common File Locations for Docker

```bash
# Docker-related directories
/var/lib/docker/               # Docker data directory
/etc/docker/                   # Docker configuration
~/.docker/                     # User Docker configuration
/var/run/docker.sock           # Docker socket file
```

## Quick Reference Card

| Command | Description |
|---------|-------------|
| `pwd` | Show current directory |
| `ls -la` | List all files with details |
| `cd dirname` | Change to directory |
| `mkdir dirname` | Create directory |
| `touch filename` | Create empty file |
| `cp file1 file2` | Copy file |
| `mv file1 file2` | Move/rename file |
| `rm filename` | Delete file |
| `cat filename` | View file content |
| `nano filename` | Edit file |
| `chmod +x file` | Make file executable |
| `ps aux` | List all processes |
| `grep text file` | Search text in file |
| `tar -czf name.tar.gz dir/` | Create compressed archive |
| `df -h` | Check disk space |

Remember: When in doubt, use `man command-name` to read the manual for any command!