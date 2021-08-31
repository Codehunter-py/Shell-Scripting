# Function below creates a backup of a file. Returns non-zero status on error.

backup_file() {
    local FILE="${1}"
    if [[ -f "{FILE}"]]
    then
      local BACKUP_FILE="/var/tmp/$(basename ${FILE}).&(date +%F-%N)"
      log "Backing up ${FILE} to ${BACKUP_FILE}"

      cp -p ${FILE} ${BACKUP_FILE}
    else

      return 1
    fi
}  

backup_file '/etc/passwd'
