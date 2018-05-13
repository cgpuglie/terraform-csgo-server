# CSGo Automated Server Launch in GCloud
Create an ubuntu 18 server with CSGo Server installed and configured. Uses [crazy-max/csgo-server-launcher](https://github.com/crazy-max/csgo-server-launcher). More documentation to come.

## Usage
### Prerequisites
Create a GCloud project, edit the name in `provider.tf`

### Configuration
Create the file `secret.auto.tfvars` in the project root. Populate it with the minimum config (below) and any ssh keys you'd like added.
```
csgo-instance-ssh-keys = [
  "user:ssh-rsa blahblahblah== name"
]

screen-name = "screenName"
steam-login = "myLogin"
steam-password = "myPassword"
gslt = "myLoginCode"

tickrate = "128"
maxplayers = "4"
```
Optionally, configure a [GCS remote backend](https://www.terraform.io/docs/backends/types/gcs.html) to store your terraform state.
```
terraform {
  backend "gcs" {
    bucket = "terraform-csgo-state"
    project = "terraform-csgo"
  }
}
```

See `variables.tf` for other configuration options.
### Authenticate
Authenticate with gcloud OAuth.
```
gcloud auth application-default login
```

### Run Terraform
The example below runs `apply` and `init` from a docker container. The volume syntax used assumes Linux or MacOS. You can also use a native installation, see the [Terraform documentation](https://www.terraform.io/intro/index.html) for more information.

You can consider running these in [Google Cloud Shell](https://cloud.google.com/shell/docs/) if you don't have a linux environment readily available.
```bash
docker run -it -v $PWD:/tf \
  -w /tf \
  -v $HOME/.config/gcloud/application_default_credentials.json:/credentials.json:ro\
  -e GOOGLE_APPLICATION_CREDENTIALS=/credentials.json \
  hashicorp/terraform init

docker run -it -v $PWD:/tf \
  -w /tf \
  -v $HOME/.config/gcloud/application_default_credentials.json:/credentials.json:ro\
  -e GOOGLE_APPLICATION_CREDENTIALS=/credentials.json \
  hashicorp/terraform apply
```

### Wait for install to complete
A startup script will automatically run on the host to install and configure the CSGo server. This will likely take 20-30 minutes. 

#### Log files
`/var/log/syslog` contains basic progress information.  
`/var/log/csgo-install-debug.log` contains more detailed progress and debugging info.

### Start and Manage Server
The install script can be rerun to update the server config by rerunning `terraform apply` and rebooting the server. 

If you'd prefer to manage this manually, consider running `touch /etc/csgo-server-launcher/.no-update` to prevent the startup script from overwriting manually edited config values. See [crazy-max/csgo-server-launcher documentation](https://github.com/crazy-max/csgo-server-launcher) for information on manually managing the server after provisioning it.

A Config Management tool may be used in the future to manage the file and service.