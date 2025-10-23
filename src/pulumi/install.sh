#!/bin/sh
set -e

# Pulumi CLI Installation Script for DevContainers
# This script installs the Pulumi CLI with checksum verification

echo "Installing Pulumi CLI..."

# Read feature options (converted to uppercase environment variables)
PULUMI_VERSION="${VERSION:-"latest"}"
SKIP_CHECKSUM_VALIDATION="${SKIPCHECKSUMVALIDATION:-"false"}"

echo "Version to install at the beginning: ${PULUMI_VERSION}"

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_ID="${ID}"
else
    echo "Error: Cannot detect OS. /etc/os-release not found."
    exit 1
fi

# Detect architecture
ARCH="$(uname -m)"
case "${ARCH}" in
    x86_64)
        PULUMI_ARCH="x64"
        ;;
    aarch64|arm64)
        PULUMI_ARCH="arm64"
        ;;
    *)
        echo "Error: Unsupported architecture: ${ARCH}"
        echo "Pulumi CLI supports x86_64 and arm64 only."
        exit 1
        ;;
esac

# Install required dependencies based on OS
echo "Installing dependencies for ${OS_ID}..."
case "${OS_ID}" in
    debian|ubuntu)
        export DEBIAN_FRONTEND=noninteractive
        apt-get update
        apt-get install -y curl ca-certificates tar gzip
        ;;
    alpine)
        apk add --no-cache curl ca-certificates tar gzip
        ;;
    rhel|centos|fedora|rocky|almalinux)
        if command -v dnf > /dev/null 2>&1; then
            dnf install -y curl ca-certificates tar gzip
        else
            yum install -y curl ca-certificates tar gzip
        fi
        ;;
    *)
        echo "Warning: Unsupported OS: ${OS_ID}. Attempting installation anyway..."
        if ! command -v curl > /dev/null 2>&1; then
            echo "Error: curl is required but not installed."
            exit 1
        fi
        ;;
esac

echo "Version to install later on: ${PULUMI_VERSION}"

# Determine version to install
if [ "${PULUMI_VERSION}" = "latest" ]; then
    echo "Fetching latest Pulumi version..."
    INSTALL_VERSION="$(curl -fsSL https://www.pulumi.com/latest-version)"
    if [ -z "${INSTALL_VERSION}" ]; then
        echo "Error: Failed to fetch latest version."
        exit 1
    fi
    echo "Latest version: ${INSTALL_VERSION}"
else
    INSTALL_VERSION="${PULUMI_VERSION}"
    # Remove 'v' prefix if present
    INSTALL_VERSION="${INSTALL_VERSION#v}"
    echo "Installing specified version: ${INSTALL_VERSION}"
fi

# Construct download URLs
PULUMI_URL="https://get.pulumi.com/releases/sdk/pulumi-v${INSTALL_VERSION}-linux-${PULUMI_ARCH}.tar.gz"
CHECKSUM_URL="https://get.pulumi.com/releases/sdk/pulumi-${INSTALL_VERSION}-checksums.txt"
ARCHIVE_FILENAME="pulumi-v${INSTALL_VERSION}-linux-${PULUMI_ARCH}.tar.gz"

echo "Download URL: ${PULUMI_URL}"

# Create temporary directory
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

# Download Pulumi archive
echo "Downloading Pulumi CLI v${INSTALL_VERSION}..."
if ! curl -fsSL -o "${TMP_DIR}/pulumi.tar.gz" "${PULUMI_URL}"; then
    echo "Error: Failed to download Pulumi from ${PULUMI_URL}"
    echo "Please verify the version exists at https://www.pulumi.com/docs/get-started/download-install/versions/"
    exit 1
fi

# Download and verify checksum
if [ "${SKIP_CHECKSUM_VALIDATION}" = "true" ]; then
    echo "WARNING: Skipping checksum validation. This reduces security!"
else
    echo "Downloading checksums file..."
    if ! curl -fsSL -o "${TMP_DIR}/checksums.txt" "${CHECKSUM_URL}"; then
        echo "Error: Failed to download checksums from ${CHECKSUM_URL}"
        echo "Please verify the version exists at https://www.pulumi.com/docs/get-started/download-install/versions/"
        exit 1
    fi

    # Verify checksum
    echo "Verifying SHA256 checksum..."
    cd "${TMP_DIR}"

    # Extract the checksum for our specific archive from the checksums file
    # The checksums file contains lines like: "<hash>  <filename>"
    EXPECTED_CHECKSUM="$(grep "${ARCHIVE_FILENAME}" checksums.txt | awk '{print $1}')"

    if [ -z "${EXPECTED_CHECKSUM}" ]; then
        echo "Error: Could not find checksum for ${ARCHIVE_FILENAME} in checksums file."
        echo "This may indicate an unsupported version or architecture."
        exit 1
    fi

    # Calculate actual checksum
    ACTUAL_CHECKSUM="$(sha256sum pulumi.tar.gz | awk '{print $1}')"

    if [ "${EXPECTED_CHECKSUM}" != "${ACTUAL_CHECKSUM}" ]; then
        echo "Error: Checksum verification failed!"
        echo "Expected: ${EXPECTED_CHECKSUM}"
        echo "Actual:   ${ACTUAL_CHECKSUM}"
        exit 1
    fi

    echo "Checksum verified successfully."
fi

# Check if Pulumi is already installed and matches version
if command -v pulumi > /dev/null 2>&1; then
    INSTALLED_VERSION="$(pulumi version | sed 's/v//')"
    if [ "${INSTALLED_VERSION}" = "${INSTALL_VERSION}" ]; then
        echo "Pulumi v${INSTALL_VERSION} is already installed. Skipping installation."
        exit 0
    else
        echo "Pulumi v${INSTALLED_VERSION} is installed, upgrading to v${INSTALL_VERSION}..."
    fi
fi

# Extract and install
echo "Installing Pulumi CLI..."
cd "${TMP_DIR}"
tar -xzf pulumi.tar.gz

# Install to /usr/local/bin
if [ ! -d "/usr/local/bin" ]; then
    mkdir -p /usr/local/bin
fi

# Copy binaries
cp -f pulumi/* /usr/local/bin/

# Make binaries executable
chmod +x /usr/local/bin/pulumi*

# Verify installation
if ! command -v pulumi > /dev/null 2>&1; then
    echo "Error: Pulumi installation failed. Command not found in PATH."
    exit 1
fi

FINAL_VERSION="$(pulumi version)"
echo "Successfully installed Pulumi ${FINAL_VERSION}"

# Display basic info
echo ""
echo "Pulumi CLI is now available. Try:"
echo "  pulumi version"
echo "  pulumi new --help"
echo ""
