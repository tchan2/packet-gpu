variable "auth_token" {
    description = "Created through the Packet Portal. Please visit https://support.packet.com/kb/articles/api-integrations for more help on creating API keys."
    default = ""
    # Please set your authentication token in `default` before running Terraform
}

variable "project_id" {
    description = "The UUID of your project, that was either created through the Packet Portal, or in your Terraform file."
    default = ""
    # Please replace the above with your project ID if you have already created it through the Packet Portal.
}

variable "hostname" {
    description = "The hostname of your device. You may change it to your liking."
    default = "gpu-testing"
}

variable "plan" {
    description = "The type of Packet server you are creating. For more servers and their details, please visit https://www.packet.com/cloud/servers/."
    default = "g2.large.x86"
}

variable "facility" {
    description = "The facility your Packet server is in. This information can be found in the 'Location' part of your preferred server's details."
    default = ["dfw2"]
}

variable "os" {
    description = "The OS your server is using. This can be found in the 'OS Support' portion of your preferred server's details."
    default = "ubuntu_16_04"
}

variable "billing_cycle" {
    description = "How often you will be billed for this server. You will be billed hourly."
    default = "hourly"
}
