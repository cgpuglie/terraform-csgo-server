# Infrastructure related variables
variable "csgo-instance-machine-type" {
  default = "g1-small"
}

variable "csgo-instance-region" {
  default = "us-west1-a"
}

variable "csgo-instance-ssh-keys" {
  type = "list"
  default = []
}

# Server config variables
# For information on values, see https://github.com/crazy-max/csgo-server-launcher#installation
variable "screen-name" {
   default = "csgo" 
}
variable "user" {
   default = "steam" 
}
variable "port" {
   default = "27015" 
}
variable "gslt" {
   default = "" 
}
variable "dir-steamcmd" {
   default = "/var/steamcmd" 
}
variable "steam-login" {
   default = "anonymous" 
}
variable "steam-password" {
   default = "anonymous" 
}
variable "steam-runscript" {
   default = "$DIR_STEAMCMD/runscript_$SCREEN_NAME" 
}
variable "dir-root" {
   default = "$DIR_STEAMCMD/games/csgo" 
}
variable "dir-game" {
   default = "$DIR_ROOT/csgo" 
}
variable "dir-logs" {
   default = "$DIR_GAME/logs" 
}
variable "daemon-game" {
   default = "srcds_run" 
}
variable "update-log" {
   default = "$DIR_LOGS/update_$(date +%Y%m%d).log" 
}
variable "update-email" {
   default = "" 
}
variable "update-retry" {
   default = 3 
}
variable "api-authorization-key" {
   default = "" 
}
variable "workshop-collection-id" {
   default = "125499818" 
}
variable "workshop-start-map" {
   default = "125488374" 
}
variable "maxplayers" {
   default = "18" 
}
variable "tickrate" {
   default = "64" 
}
variable "extraparams" {
   default = "-nohltv +sv_pure 0 +game_type 0 +game_mode 0 +mapgroup mg_bomb +map de_dust2" 
}
variable "param-start" {
   default = "-nobreakpad -game csgo -console -usercon -secure -autoupdate -steam_dir $DIR_STEAMCMD -steamcmd_script $STEAM_RUNSCRIPT -maxplayers_override $MAXPLAYERS -tickrate $TICKRATE +hostport $PORT +net_public_adr $IP $EXTRAPARAMS" 
}
variable "param-update" {
   default = "+login $STEAM_LOGIN $STEAM_PASSWORD +force_install_dir $DIR_ROOT +app_update 740 validate +quit" 
}
