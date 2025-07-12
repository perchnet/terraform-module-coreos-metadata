terraform {
  required_version = ">= 1.0"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
  }
}

module "coreos_metadata" {
  source = "../"
}

resource "null_resource" "metadata_values" {
  triggers = {
    stream_url                = module.coreos_metadata.stream_url
    release                   = module.coreos_metadata.release
    download_url              = module.coreos_metadata.download_url
    download_sum              = module.coreos_metadata.download_sum
    download_sum_uncompressed = module.coreos_metadata.download_sum_uncompressed
    download_signature        = module.coreos_metadata.download_signature
    coreos_img_filename       = module.coreos_metadata.coreos_img_filename
  }
}

# Basic sanity checks
resource "null_resource" "metadata_checks" {
  triggers = {
    check_stream_url          = strcontains(module.coreos_metadata.stream_url, "https://") ? "ok" : "invalid"
    check_release             = length(module.coreos_metadata.release) > 0 ? "ok" : "invalid"
    check_download_url        = strcontains(module.coreos_metadata.download_url, "https://") ? "ok" : "invalid"
    check_download_sum        = length(module.coreos_metadata.download_sum) == 64 ? "ok" : "invalid"              # sha256 length
    check_sum_uncompressed    = length(module.coreos_metadata.download_sum_uncompressed) == 64 ? "ok" : "invalid" # sha256 length
    check_download_signature  = strcontains(module.coreos_metadata.download_signature, ".sig") ? "ok" : "invalid"
    check_coreos_img_filename = strcontains(module.coreos_metadata.coreos_img_filename, ".xz") ? "ok" : "invalid"
  }

  lifecycle {
    postcondition {
      condition     = alltrue([for k, v in self.triggers : v == "ok"])
      error_message = "One or more metadata checks failed."
    }
  }
}
