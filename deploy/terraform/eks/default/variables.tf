variable "environment_name" {
  type    = string
  default = "qualgo-lab"
}

variable "istio_enabled" {
  description = "Boolean value that enables istio."
  type        = bool
  default     = false
}

variable "opentelemetry_enabled" {
  description = "Boolean value that enables OpenTelemetry."
  type        = bool
  default     = false
}

variable "container_image_overrides" {
  type        = any
  default     = {}
  description = "Container image override object"
}
