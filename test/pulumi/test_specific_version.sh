#!/bin/bash
set -e

# Test script for specific version scenario
# This script tests that version 3.100.0 of Pulumi CLI is installed correctly

EXPECTED_VERSION="3.200.0"

echo "Testing Pulumi CLI installation (specific version: $EXPECTED_VERSION)..."

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

# Test 4: Verify the specific version is installed
echo "Test 4: Verifying specific version $EXPECTED_VERSION is installed..."
INSTALLED_VERSION=$(pulumi version | sed 's/v//')
if [ "$INSTALLED_VERSION" != "$EXPECTED_VERSION" ]; then
    echo "FAIL: Expected version v$EXPECTED_VERSION but got v$INSTALLED_VERSION"
    exit 1
fi
echo "PASS: Correct version installed: v$INSTALLED_VERSION"

# Test 5: Check if pulumi help works
echo "Test 5: Checking pulumi help command..."
if ! pulumi --help > /dev/null; then
    echo "FAIL: pulumi help command failed"
    exit 1
fi
echo "PASS: pulumi help command works"

echo ""
echo "All tests passed successfully!"
echo "Pulumi CLI version $EXPECTED_VERSION is installed and working correctly."
