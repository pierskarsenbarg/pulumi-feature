#!/bin/bash
set -e

# Test script for Pulumi feature
# This script tests that Pulumi CLI is installed correctly

echo "Testing Pulumi CLI installation..."

# Test 1: Check if pulumi command exists
echo "Test 1: Checking if pulumi command is available..."
if ! command -v pulumi &> /dev/null; then
    echo "FAIL: pulumi command not found in PATH"
    exit 1
fi
echo "PASS: pulumi command is available"

# Test 2: Verify pulumi version command works
echo "Test 2: Checking pulumi version command..."
if ! pulumi version; then
    echo "FAIL: pulumi version command failed"
    exit 1
fi
echo "PASS: pulumi version command works"

# Test 3: Check if version output is valid format
echo "Test 3: Verifying version format..."
VERSION=$(pulumi version)
if [[ ! $VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+ ]]; then
    echo "FAIL: Invalid version format: $VERSION"
    exit 1
fi
echo "PASS: Version format is valid: $VERSION"

# Test 4: Check if pulumi help works
echo "Test 4: Checking pulumi help command..."
if ! pulumi --help > /dev/null; then
    echo "FAIL: pulumi help command failed"
    exit 1
fi
echo "PASS: pulumi help command works"

# Test 5: Verify binaries are executable
echo "Test 5: Checking if binaries are executable..."
if [ ! -x "$(command -v pulumi)" ]; then
    echo "FAIL: pulumi binary is not executable"
    exit 1
fi
echo "PASS: pulumi binary is executable"

# Test 6: Check environment variable
echo "Test 6: Checking PULUMI_SKIP_UPDATE_CHECK environment variable..."
if [ "${PULUMI_SKIP_UPDATE_CHECK}" != "true" ]; then
    echo "WARNING: PULUMI_SKIP_UPDATE_CHECK is not set to 'true' (current value: ${PULUMI_SKIP_UPDATE_CHECK})"
    echo "This is not critical but recommended for CI/CD environments"
fi
echo "PASS: Environment variable check complete"

echo ""
echo "All tests passed successfully!"
echo "Pulumi CLI is installed and working correctly."
