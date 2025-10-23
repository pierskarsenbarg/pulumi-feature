#!/bin/bash
set -e

# Test script for latest version scenario
# This script tests that the latest version of Pulumi CLI is installed correctly

echo "Testing Pulumi CLI installation (latest version)..."

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

# Test 4: Verify it's a reasonably recent version (v3.x or higher)
echo "Test 4: Checking version is recent (v3.x or higher)..."
MAJOR_VERSION=$(echo $VERSION | sed 's/v\([0-9]*\)\..*/\1/')
if [ "$MAJOR_VERSION" -lt 3 ]; then
    echo "FAIL: Version $VERSION is too old (expected v3.x or higher)"
    exit 1
fi
echo "PASS: Version is recent: $VERSION"

# Test 5: Check if pulumi help works
echo "Test 5: Checking pulumi help command..."
if ! pulumi --help > /dev/null; then
    echo "FAIL: pulumi help command failed"
    exit 1
fi
echo "PASS: pulumi help command works"

echo ""
echo "All tests passed successfully!"
echo "Pulumi CLI latest version is installed and working correctly."
