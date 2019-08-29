variable "project_id" {}
variable "hostname" {}
variable "plan" {}
variable "facility" {}
variable "os" {}
variable "billing_cycle" {}

resource "packet_device" "tf-gpu" {
  project_id       = "${var.project_id}"
  hostname         = "${var.hostname}"
  plan             = "${var.plan}"
  facilities       = "${var.facility}"
  operating_system = "${var.os}"
  billing_cycle    = "${var.billing_cycle}"
  user_data        = "${data.template_file.tf_userdata.rendered}"
}

# References a file with script of necessary installations after server is created.
data "template_file" "tf_userdata" {
  template = "${file("${path.module}/tf_userdata.sh.tpl")}"
}