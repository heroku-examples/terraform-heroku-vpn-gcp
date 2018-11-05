# Heroku Private Space VPN connection to Google Cloud Platform using Terraform

[![Build Status](https://travis-ci.org/heroku-examples/terraform-heroku-vpn-gcp.svg?branch=master)](https://travis-ci.org/heroku-examples/terraform-heroku-vpn-gcp)

A Heroku [Private Space](https://devcenter.heroku.com/articles/private-spaces) provides a container for [internally routed apps](https://devcenter.heroku.com/articles/internal-routing) that are only accessible within its private network.

[Private Space VPN Connections](https://devcenter.heroku.com/articles/private-space-vpn-connection) provide site-to-site interconnection with [Google Cloud VPN](https://cloud.google.com/vpn/docs/concepts/overview).

Apps on either side of the VPN connection may access apps on the other side other by DNS name via the established IPSec network tunnels. Two tunnels provide redundancy to ensure uninterrupted network connectivity.

A single [Terraform config](https://www.terraform.io/docs/configuration/index.html) embodies the complete integration between Heroku and Google Cloud Platform, enabling high-level collaboration, repeatability, test-ability, and change management.

## Primary components

* [Heroku](https://www.heroku.com/home)
* [Google Cloud Platform](https://cloud.google.com/)
* [Terraform](https://terraform.io)

## Challenges & Caveats

* **Config drift when using Heroku or Google Dashboard or CLI.** Once the config is applied, if changes are made to the resources outside of Terraform, then the Terraform state will no longer match its configuration, making it impossible to apply or destroy further until the drifting values are imported (for new resources) or manually updated in `terraform.tfstate`.

## Requirements

* [Heroku](https://www.heroku.com/home)
  * install [command-line tools (CLI)](https://toolbelt.heroku.com)
  * [an account](https://signup.heroku.com) (must be a member of an Enterprise account for access to Private Spaces)
  * [a team](https://devcenter.heroku.com/articles/heroku-teams) in the Enterprise account
* [Google Cloud](https://cloud.google.com/)
  * install [Cloud SDK](https://cloud.google.com/sdk/)
  * [an account](https://console.cloud.google.com/freetrial)
* install [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* install [Terraform](https://terraform.io)

## Usage

### As a module

Use this module from another Terraform configuration to provision the Google Cloud resources for Private Spaces VPN:

```hcl
provider "google" {
  version = "~> 1.19"
  region  = "${var.google_region}"
}

provider "heroku" {
  version = "~> 1.5"
}

module "heroku_vpn_gcp" {
  source = "github.com/heroku-examples/terraform-heroku-vpn-gcp"

  providers = {
    google = "google"
  }

  // …input variables
}
```

👓 See [examples](examples/) for usage details.

### Complete example

Ensure the [requirements](#user-content-requirements) are met, then,

1. Clone this repo:

    ```bash
    git clone git@github.com:heroku-examples/terraform-heroku-vpn-gcp.git
    cd terraform-heroku-vpn-gcp/
    ```
1. Set Heroku API key
    1. `heroku authorizations:create -d terraform-heroku-vpn-gcp`
    2. `export HEROKU_API_KEY=<"Token" value from the authorization>`
1. Login & configure Google Cloud
    1. `gcloud init`
    1. `gcloud auth application-default login`
    1. `export GOOGLE_PROJECT=<project-name>`
1. `cd examples/heroku-private-space`
1. `terraform init`
1. Optionally, import any existing resources:
    * **Heroku Private Space**
      * `terraform import heroku_space.default <Name or ID>`
      * When running subsequent Terraform commands, the `heroku_enterprise_team`, `heroku_private_space`, & `heroku_private_space_region` input variables must match the existing Private Space's values
    * **Google VPC Network**
      * `terraform import google_compute_network.default <Name>`
      * When running subsequent Terraform commands, the `google_network` & `google_network_auto_create_subnetworks` input variable must match the existing network's values
    * **Google VPC Subnetwork**
      * `terraform import google_compute_subnetwork.default <Name>`
      * When running subsequent Terraform commands, the `google_subnetwork`, `google_subnetwork_cidr_block`, `google_subnetwork_private_ip_access`, & `google_region` input variables must match the existing subnet's values
1. Then, apply the config with your own top-level config values:

    ```bash
    terraform apply \
      -var heroku_enterprise_team=example-team \
      -var heroku_private_space=example-space \
      -var heroku_private_space_region=oregon \
      -var google_region=us-west1
    ```

-----

🔬 This is a community proof-of-concept, [MIT license](LICENSE), provided "as is", without warranty of any kind.
