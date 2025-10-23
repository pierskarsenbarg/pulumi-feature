
# Pulumi CLI (pulumi)

Installs the Pulumi CLI for infrastructure as code development

## Example Usage

```json
"features": {
    "ghcr.io/pierskarsenbarg/pulumi-feature/pulumi:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Version of Pulumi CLI to install. Use 'latest' for the most recent stable release. See https://www.pulumi.com/docs/get-started/download-install/versions/ for available versions. | string | latest |
| skipChecksumValidation | Skip SHA256 checksum validation (NOT RECOMMENDED - reduces security) | boolean | false |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/pierskarsenbarg/pulumi-feature/blob/main/src/pulumi/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
