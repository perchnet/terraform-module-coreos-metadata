# Terraform CoreOS Metadata Module

This Terraform module retrieves metadata for Fedora CoreOS virtualization images. It fetches information from the official CoreOS stream metadata endpoint and provides details about download URLs, checksums, and other relevant data for a specified platform, stream, architecture, and format.

It's only tested for the `proxmoxve` platform, and may need adjustments for other platforms.

## Usage

```hcl
module "coreos_metadata" {
  source = "github.com/b-/terraform-module-coreos-metadata"

  platform = "proxmoxve"
  stream   = "testing"
}

output "coreos_download_url" {
  value = module.coreos_metadata.download_url
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `platform` | The CoreOS platform (e.g., `proxmoxve`, `qemu`, `vmware`). | `string` | `"proxmoxve"` | no |
| `stream_url` | Override the default CoreOS stream URL. | `string` | `null` | no |
| `stream` | The CoreOS stream to use (e.g., `stable`, `testing`, `next`). | `string` | `"testing"` | no |
| `architecture` | The CPU architecture (e.g., `x86_64`, `aarch64`). | `string` | `"x86_64"` | no |
| `format` | The image format (e.g., `qcow2.xz`, `vmdk.xz`). | `string` | `"qcow2.xz"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `stream_url` | The URL of the CoreOS stream metadata. |
| `release` | The release version of the CoreOS image. |
| `download_url` | The direct download URL for the CoreOS image. |
| `download_sum` | The SHA256 checksum of the compressed CoreOS image. |
| `download_sum_uncompressed` | The SHA256 checksum of the uncompressed CoreOS image. |
| `download_signature` | The signature for the downloaded image. |
| `coreos_img_filename` | The filename of the CoreOS image. |
