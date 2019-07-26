# All variables used here can be changed in the `variables.tf` file.

provider "packet" {
    auth_token = "${var.auth_token}"
    # Please set your authentication token in `variables.tf` before running Terraform
}

resource "packet_project" "tf_project" {
    name = "Project 1"
    # If you do not need to create a project, please set your project_id in `variables.tf` before running
    # Terraform and delete or comment out this resource so a new project will not be created.
}

resource "packet_device" "tf-gpu" {
    # If you already have a project_id, please change project_id to:
    # project_id          = "${var.project_id}"
    project_id          = "${packet_project.tf_project.id}"
    hostname            = "${var.hostname}"
    plan                = "${var.plan}"
    facilities          = ["${var.facility}"]
    operating_system    = "${var.os}"
    billing_cycle       = "${var.billing_cycle}"
    user_data           = "${data.template_file.tf_userdata.rendered}"
}

# References a file with script of necessary installations after server is created.
data "template_file" "tf_userdata" {
    template = "${file("tf_userdata.sh.tpl")}"
}