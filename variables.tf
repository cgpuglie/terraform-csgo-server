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