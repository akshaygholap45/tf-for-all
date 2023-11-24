variable "db_password" {
  type = string
  sensitive = true
  description = "Webserver DB Password"
}

variable "db_root_password" {
  type = string
  sensitive = true
  description = "Webserver DB Root Password"
}