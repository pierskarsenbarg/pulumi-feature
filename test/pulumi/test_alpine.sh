#!/bin/bash
set -e

# Test script for Alpine Linux scenario
# This script tests that Pulumi CLI is installed correctly on Alpine

echo "Testing Pulumi CLI installation on Alpine Linux..."

# Test 1: Verify we're on Alpine
echo "Test 1: Verifying Alpine Linux..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" != "alpine" ]; then
        echo "WARNING: Expected Alpine Linux but found: $ID"
    else
        echo "PASS: Running on Alpine Linux"
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

# Test 6: Verify required dependencies are available
echo "Test 6: Checking required dependencies on Alpine..."
DEPS="curl tar gzip"
for dep in $DEPS; do
    if ! command -v $dep &> /dev/null; then
        echo "WARNING: Dependency $dep not found (may have been cleaned up)"
    fi
done
echo "PASS: Dependency check complete"

echo ""
echo "All tests passed successfully!"
echo "Pulumi CLI is installed and working correctly on Alpine Linux."
