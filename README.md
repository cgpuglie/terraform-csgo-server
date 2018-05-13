# CSGo Automated Server Launch in GCloud
Create an ubuntu 18 server with CSGo Server installed and configured. Uses [crazy-max/csgo-server-launcher](https://github.com/crazy-max/csgo-server-launcher) to install and configure the server. More documentation to come.

## Usage
### Configuration
Add SSH Keys to `secret.auto.tfvars`
```
csgo-instance-ssh-keys = [
  "user:ssh-rsa blahblahblah== name"
]
```
Optionally, configure a remote backend.
```
terraform {
  backend "gcs" {
    bucket = "terraform-csgo-state"
    project = "terraform-csgo"
  }
}
```

### Authenticate
Authenticate with gcloud OAuth.
```
gcloud auth application-default login
```

### Run Terraform
The example below initializes and runs `apply` with docker. You can also use a native installation, see the terraform documentation.
```
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

### Start and Manage Server
This piece is manual, I may consider adding some basic Ansible or Chef in the future. For now, you can follow the  [crazy-max/csgo-server-launcher documentation](https://github.com/crazy-max/csgo-server-launcher) for managing the server.