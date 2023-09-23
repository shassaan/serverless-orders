variable "name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type      = string
  sensitive = true
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "subnets" {
  type = set(string)
}