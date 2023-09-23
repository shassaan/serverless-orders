variable "client_subnets" {
  type = set(string)
}

variable "security_groups" {
  type = set(string)
}

variable "cluster_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ver" {
  type = string
}

variable "ebs_volume_size" {
  type = number
}

variable "broker_nodes" {
  type = number
}