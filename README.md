# Pulumi DevContainer Feature

A [DevContainer feature](https://containers.dev/implementors/features/) that installs the Pulumi CLI into your development container.

## Quick Start

Add this to your `.devcontainer/devcontainer.json`:

```json
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/pierskarsenbarg/pulumi-feature/pulumi:1": {}
    }
}
```

Then rebuild your container, and Pulumi will be ready to use!

## Usage

### Install Latest Version (Default)

```json
{
    "features": {
        "ghcr.io/pierskarsenbarg/pulumi-feature/pulumi:1": {}
    }
}
```

### Install Specific Version

```json
{
    "features": {
        "ghcr.io/pierskarsenbarg/pulumi-feature/pulumi:1": {
            "version": "3.203.0"
        }
    }
}
```

See [available versions](https://www.pulumi.com/docs/get-started/download-install/versions/) for a complete list.

### With Authentication

To automatically authenticate with Pulumi Cloud, pass your access token:

```json
{
    "features": {
        "ghcr.io/pierskarsenbarg/pulumi-feature/pulumi:1": {}
    },
    "remoteEnv": {
        "PULUMI_ACCESS_TOKEN": "${localEnv:PULUMI_ACCESS_TOKEN}"
    }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | Pulumi version to install (e.g., "3.203.0" or "latest"). See [available versions](https://www.pulumi.com/docs/get-started/download-install/versions/). |
| `skipChecksumValidation` | boolean | `false` | Skip SHA256 checksum validation (NOT RECOMMENDED) |

## Supported Platforms

### Operating Systems

- Ubuntu
- Debian
- Alpine Linux
- RHEL / CentOS / Fedora
- Rocky Linux / AlmaLinux

### Architectures

- x86_64 (amd64)
- arm64 (aarch64)

## Development

### Structure

```console
.
├── src/
│   └── pulumi/
│       ├── devcontainer-feature.json
│       ├── install.sh
│       └── README.md
└── test/
    └── pulumi/
        ├── test.sh
        └── scenarios.json
```

### Testing Locally

You can test this feature locally using the [Dev Container CLI](https://github.com/devcontainers/cli):

```bash
# Install the CLI
npm install -g @devcontainers/cli

# Run tests
devcontainer features test

# Test against specific base image
devcontainer features test --base-image ubuntu:22.04

# Test specific scenario
devcontainer features test --filter test_alpine
```

### Manual Testing

Create a `.devcontainer/devcontainer.json`:

```json
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "./src/pulumi": {
            "version": "latest"
        }
    }
}
```

Then open in VS Code or use:

```bash
devcontainer up --workspace-folder .
```

## Security

This feature implements several security best practices:

1. **Checksum Verification**: All downloads are verified against official SHA256 checksums
2. **HTTPS Only**: All downloads use HTTPS
3. **Fail Fast**: Installation aborts immediately if checksums don't match
4. **Official Sources**: Downloads only from Pulumi's official release site

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see [LICENSE](LICENSE) file for details.

