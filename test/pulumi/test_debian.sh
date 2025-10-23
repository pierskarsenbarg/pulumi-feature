#!/bin/bash
set -e

# Test script for Debian scenario
# This script tests that Pulumi CLI is installed correctly on Debian

echo "Testing Pulumi CLI installation on Debian..."

# Test 1: Verify we're on Debian/Ubuntu (Debian-based)
echo "Test 1: Verifying Debian-based system..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" != "debian" && "$ID" != "ubuntu" ]]; then
        echo "WARNING: Expected Debian-based system but found: $ID"
    else
        echo "PASS: Running on Debian-based system ($ID)"
    fi
fi

# Test 2: Check if pulumi command exists
echo "Test 2: Checking if pulumi command is available..."
if ! command -v pulumi &> /dev/null; then
    echo "FAIL: pulumi command not found in PATH"
    exit 1
fi
echo "PASS: pulumi command is available"

# Test 3: Verify pulumi version command works
echo "Test 3: Checking pulumi version command..."
if ! pulumi version; then
    echo "FAIL: pulumi version command failed"
    exit 1
fi
echo "PASS: pulumi version command works"

# Test 4: Check if version output is valid format
echo "Test 4: Verifying version format..."
VERSION=$(pulumi version)
if [[ ! $VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+ ]]; then
    echo "FAIL: Invalid version format: $VERSION"
    exit 1
fi
echo "PASS: Version format is valid: $VERSION"

# Test 5: Check if pulumi help works
echo "Test 5: Checking pulumi help command..."
if ! pulumi --help > /dev/null; then
    echo "FAIL: pulumi help command failed"
    exit 1
fi
echo "PASS: pulumi help command works"

# Test 6: Verify binaries are executable
echo "Test 6: Checking if binaries are executable..."
if [ ! -x "$(command -v pulumi)" ]; then
    echo "FAIL: pulumi binary is not executable"
    exit 1
fi
echo "PASS: pulumi binary is executable"

echo ""
echo "All tests passed successfully!"
echo "Pulumi CLI is installed and working correctly on Debian."
