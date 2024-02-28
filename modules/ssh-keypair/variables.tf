variable "key_name" {
  description = "Keyname for the SSH keypair"
  type        = string
}

variable "algorithm_name" {
  description = "Algorithm for the SSH keypair"
  type        = string
}

variable "keypair_bits" {
  description = "Bits for the SSH keypair"
  type        = number
}
