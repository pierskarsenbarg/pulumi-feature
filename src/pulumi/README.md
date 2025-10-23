# Pulumi CLI (pulumi)

**Installs the Pulumi CLI for infrastructure as code development**

This feature installs the [Pulumi CLI](https://www.pulumi.com/) into your development container, allowing you to manage cloud infrastructure as code using your favorite programming languages.

## Example Usage

```json
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/pierskarsenbarg/pulumi-feature/pulumi:1": {}
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|------------|-------------|------|---------------|
| version | Version of Pulumi CLI to install. Use 'latest' for the most recent stable release or specify a version like '3.203.0'. See [available versions](https://www.pulumi.com/docs/get-started/download-install/versions/). | string | latest |
| skipChecksumValidation | Skip SHA256 checksum validation (NOT RECOMMENDED - reduces security) | boolean | false |

## Examples

### Install Latest Version

```json
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/pierskarsenbarg/pulumi-feature/pulumi:1": {}
    }
}
```

### Install Specific Version

```json
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/pierskarsenbarg/pulumi-feature/pulumi:1": {
            "version": "3.203.0"
        }
    }
}
```

You can find all available versions at [Pulumi's versions page](https://www.pulumi.com/docs/get-started/download-install/versions/).

### Multiple Versions (for testing)

While you can only have one version of Pulumi installed per container, you can create different containers with different versions:

```json
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/pierskarsenbarg/pulumi-feature/pulumi:1": {
            "version": "3.99.0"
        }
    }
}
```

## Supported Platforms

This feature supports the following platforms:

- **Operating Systems**: Ubuntu, Debian, Alpine, RHEL, CentOS, Fedora, Rocky Linux, AlmaLinux
- **Architectures**: x86_64 (amd64), arm64 (aarch64)

## Environment Variables

The feature automatically sets the following environment variable:

- `PULUMI_SKIP_UPDATE_CHECK=true` - Disables automatic update checks to avoid interrupting your workflow

## Security

By default, this feature validates the SHA256 checksum of the downloaded Pulumi CLI archive against the official checksum provided by Pulumi. This ensures the integrity and authenticity of the downloaded files.

**Warning**: Setting `skipChecksumValidation` to `true` disables this security check and is not recommended unless you are in a controlled environment where checksum validation causes issues.

## How It Works

1. Detects your container's operating system and architecture
2. Determines the version to install (latest or specified)
3. Downloads the Pulumi CLI archive from the official release site
4. Downloads and verifies the SHA256 checksum
5. Extracts and installs the Pulumi CLI to `/usr/local/bin`
6. Verifies the installation was successful

The installation is idempotent - if the requested version is already installed, the script will skip the installation.

## After Installation

Once installed, you can use Pulumi commands directly:

```bash
# Check version
pulumi version

# Login to Pulumi Cloud or self-hosted backend
pulumi login

# Create a new project
pulumi new aws-typescript

# Preview infrastructure changes
pulumi preview

# Deploy infrastructure
pulumi up
```

## Authentication

To use Pulumi, you'll need to authenticate with either:

1. **Pulumi Cloud** (SaaS): Run `pulumi login` and follow the prompts
2. **Self-hosted backend**: Run `pulumi login --cloud-url <your-url>`
3. **Local state**: Run `pulumi login --local` to use the local filesystem

You can set the `PULUMI_ACCESS_TOKEN` environment variable in your devcontainer.json to automatically authenticate:

```json
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/pierskarsenbarg/pulumi-feature/pulumi:1": {}
    },
    "remoteEnv": {
        "PULUMI_ACCESS_TOKEN": "${localEnv:PULUMI_ACCESS_TOKEN}"
    }
}
```

## Troubleshooting

### Version not found

If you specify a version that doesn't exist, you'll see an error like:

```
Error: Failed to download Pulumi from https://get.pulumi.com/releases/sdk/pulumi-vX.Y.Z-linux-x64.tar.gz
Please verify the version exists at https://github.com/pulumi/pulumi/releases
```

Check [Pulumi releases](https://github.com/pulumi/pulumi/releases) for available versions.

### Checksum verification failed

If checksum verification fails, the installation will abort with:

```
Error: Checksum verification failed!
Expected: <hash>
Actual:   <hash>
```

This indicates the downloaded file may be corrupted or tampered with. Try rebuilding the container. If the issue persists, check the [Pulumi releases page](https://github.com/pulumi/pulumi/releases).

### Unsupported architecture

Pulumi CLI only supports x86_64 and arm64 architectures. If you're using a different architecture, you'll see:

```
Error: Unsupported architecture: <arch>
Pulumi CLI supports x86_64 and arm64 only.
```

## Links

- [Pulumi Documentation](https://www.pulumi.com/docs/)
- [Pulumi GitHub](https://github.com/pulumi/pulumi)
- [Pulumi Releases](https://github.com/pulumi/pulumi/releases)
- [Feature Repository](https://github.com/pierskarsenbarg/pulumi-feature)

## License

This feature is released under the MIT License. See the [LICENSE](https://github.com/pierskarsenbarg/pulumi-feature/blob/main/LICENSE) file for details.

Pulumi itself is licensed under the Apache License 2.0. See [Pulumi's license](https://github.com/pulumi/pulumi/blob/master/LICENSE) for details.
