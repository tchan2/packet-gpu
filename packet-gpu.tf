# All variables used here can be changed in the `variables.tf` file.

provider "packet" {
    auth_token = "${var.auth_token}"
    # Please set your authentication token in `variables.tf` before running Terraform
}

resource "packet_project" "tf_project" {
    name = "Project 1"
    # If you do not need to create a project, please set your project_id in `variables.tf` before running Terraform
}

resource "packet_device" "tf-gpu" {
    hostname            = "${var.hostname}"
    plan                = "${var.plan}"
    facilities          = ["${var.facility}"]
    operating_system    = "${var.os}"
    billing_cycle       = "${var.billing_cycle}"
    project_id          = "${var.project_id}"
    user_data           = "${data.template_file.tf_userdata.rendered}"
}

# References a file with script of necessary installations after server is created.
data "template_file" "tf_userdata" {
    template = "${file("${var.script}")}"
}
