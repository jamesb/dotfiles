# Prepend new items to path (if directory exists)
prepend-path "/snap/bin"
prepend-path "/usr/local/bin"
prepend-path "/mnt/c/Program Files/Oracle/VirtualBox"
prepend-path "/mnt/c/HashiCorp/Vagrant/bin"
prepend-path "/mnt/c/Windows/System32"

# Remove duplicates (preserving prepended items)
# Source: http://unix.stackexchange.com/a/40755
PATH=`echo -n $PATH | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}'`

# Wrap up
export PATH
