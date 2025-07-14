terraform {
  required_version = ">= 1.0"
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = ">= 3.5.0"
    }
  }
}
variable "platform" {
  type        = string
  default     = "proxmoxve"
  description = "coreos platform"
}
variable "stream_url" {
  type        = string
  default     = null
  description = "override the stream url"
}
variable "stream" {
  type    = string
  default = "testing"
}
variable "architecture" {
  type    = string
  default = "x86_64"
}
variable "format" {
  type    = string
  default = "qcow2.xz"
}
locals {
  stream_url = coalesce(var.stream_url, "https://builds.coreos.fedoraproject.org/streams/${var.stream}.json")
}
data "http" "coreos_stream_metadata" {
  url = local.stream_url
}

locals {
  metadata = jsondecode(data.http.coreos_stream_metadata.response_body)

  artifacts = local.metadata.architectures[var.architecture].artifacts[var.platform]
  release   = local.artifacts.release

  disk_metadata             = local.artifacts.formats[var.format].disk
  download_url              = local.disk_metadata.location
  download_sum              = local.disk_metadata.sha256
  download_sum_uncompressed = try(local.disk_metadata.uncompressed-sha256, null)
  download_signature        = local.disk_metadata.signature

  coreos_img_filename = basename(local.download_url)
}

output "stream_url" {
  value = local.stream_url
}
output "release" {
  value = local.release
}
output "download_url" {
  value = local.download_url
}
output "download_sum" {
  value = local.download_sum
}
output "download_sum_uncompressed" {
  value = local.download_sum_uncompressed
}
output "download_signature" {
  value = local.download_signature
}
output "coreos_img_filename" {
  value = local.coreos_img_filename
}
