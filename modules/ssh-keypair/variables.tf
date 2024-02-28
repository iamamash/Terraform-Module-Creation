# Variable for the SSH keypair name
variable "key_name" {
  description = "Keyname for the SSH keypair"
  type        = string
}

# Variable for the algorithm for the SSH keypair 
variable "algorithm_name" {
  description = "Algorithm for the SSH keypair"
  type        = string
}

# Variable for the bits for the SSH keypair (e.g., 4096
variable "keypair_bits" {
  description = "Bits for the SSH keypair"
  type        = number
}
