variable "auth_token" {
    default = "${env.PACKET_AUTH_TOKEN}"
}

provider "packet" {
    auth_token = "${local.auth_token}"
}

locals {
    project_id = "a8a360a5-f0a4-45cf-a61b-e90a682efe3e"
    # UUID of your project
}

resource "packet_device" "tf-gpu" {
    hostname            = "gpu-testing"
    plan                = "g2.large.x86"
    facility            = "dfw2"
    operating_system    = "ubuntu_16_04"
    billing_cycle       = "hourly"
    project_id          = "${local.project_id}"
}