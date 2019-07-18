variable "auth_token" {}
# variable "project_id" {}

provider "docker" {}

provider "packet" {
    auth_token = "${var.auth_token}"
}

locals {
    project_id = "a8a360a5-f0a4-45cf-a61b-e90a682efe3e"
    # UUID of your project
}

resource "packet_device" "tf-gpu" {
    hostname            = "gpu-testing"
    plan                = "g2.large.x86"
    facilities          = ["dfw2"]
    operating_system    = "ubuntu_16_04"
    billing_cycle       = "hourly"
    project_id          = "${local.project_id}"
    # project_id          = "${var.project_id}"
}

resource "docker_container" "ubuntu" {
    name = "gpu-container"
    image = "nvcr.io/nvidia/tensorflow:latest-gpu"
    start = true

}