variable "public_key" {
    type        = string
    description = "public key for aws"
    default     = "~/.ssh/id_rsa.pub"
}

variable "environments" {
    type = map(string)
    default = {
        dev = "dev-server"
        stage = "staging-server"
        prod = "prod-server"
    }
}