#!/bin/bash

## Use crazy-max/csgo-server-launcher to install SteamCMD and CSGo server
## Info here: https://github.com/crazy-max/csgo-server-launcher

# Declare some constants
GOOGLE_METADATA_BASE="http://metadata.google.internal/computeMetadata/v1/instance"
DEBUG_LOG_DIR="/var/log/csgo-install-debug.log"
INSTALL_SCRIPT_PATH="/tmp/install.sh"
CONFIG_FILE="/etc/csgo-server-launcher/csgo-server-launcher.conf"
CONFIG_LOCK_FILE="/etc/csgo-server-launcher/.no-update"


# Declare some functions
log() {
  level=$1
  message=$2
  echo "[$level] $message"
}
fatal() {
  log "FATAL" "See $DEBUG_LOG_DIR for more information"
  exit 1
}

# Pull and run script if install doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
  log "INFO" "Pulling crazy-max/csgo-server-launcher install script"
  wget -O "$INSTALL_SCRIPT_PATH" https://raw.githubusercontent.com/crazy-max/csgo-server-launcher/master/install.sh 2>&1 >> $DEBUG_LOG_DIR || {
    log "ERROR" "Failed to pull install script!"
    fatal
  }
  log "INFO" "Running install.sh"
  chmod +x "$INSTALL_SCRIPT_PATH" 2>&1 >> $DEBUG_LOG_DIR || {
    log "ERROR" "Failed to add executable bit!"
    fatal
  }
  $INSTALL_SCRIPT_PATH 2>&1 >> $DEBUG_LOG_DIR || {
    log "ERROR" "Install script failed!"
    fatal
  }
else
  log "WARN" "Previous installation found, skipping"
fi

if [ ! -f "$CONFIG_LOCK_FILE" ]; then 
# Pull config from metadata
log "INFO" "Querying instance metadata for configuration"
## Get Public IP
PUBLIC_IP="$(curl -s "$GOOGLE_METADATA_BASE/network-interfaces/0/access-configs/0/external-ip" -H "Metadata-Flavor: Google")" || {
  log "ERROR" "Failed to get public IP!"
  fatal
}
curl -so $CONFIG_FILE "$GOOGLE_METADATA_BASE/attributes/csgo-server-conf" -H "Metadata-Flavor: Google" || {
  log "ERROR" "Failed to get configuration!"
  fatal
}
cat <<EOF >> $CONFIG_FILE
# Appended by startup script
IP="$PUBLIC_IP"
EOF

else
  log "WARN" "Lock ($CONFIG_LOCK_FILE) found, will not update"
fi

# Install CSGo Server
if [ ! -f "$CONFIG_FILE" ]; then
  log "INFO" "Installing CSGo Server, this may take a while..."
  log "INFO" "Tail $DEBUG_LOG_DIR for progress"
  /etc/init.d/csgo-server-launcher create 2>&1 >> $DEBUG_LOG_DIR || {
    log "ERROR" "Failed to install CSGo Server!"
    fatal
  }
else
  log "WARN" "Previous installation found, skipping"
fi

sudo /etc/init.d/csgo-server-launcher start