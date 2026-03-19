variable "environment" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "container_image" {
  description = "Imagen Docker del backend"
  type        = string
}