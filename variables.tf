variable "public_key" {
  description = "Body of the public key"
  type        = "string"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = "map"
}

variable "home_directory" {
  description = "directory to user sftp"
  type        = "string"
}

variable "account_number" {
  description = "account number of this account aws"
  type        = "string"
}
