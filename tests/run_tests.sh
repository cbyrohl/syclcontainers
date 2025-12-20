#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FAILED=0

# Detect compiler
if [ -z "$CXX" ]; then
    if command -v icpx &> /dev/null; then
        CXX=icpx
    elif command -v acpp &> /dev/null; then
        CXX=acpp
    else
        echo "ERROR: No SYCL compiler found"
        exit 1
    fi
fi

echo "=== Using compiler: $CXX ==="
echo ""

echo "=== Compiling SYCL test ==="
# AdaptiveCpp (acpp) doesn't use -fsycl flag
if [ "$CXX" = "acpp" ]; then
    $CXX -O2 "$SCRIPT_DIR/vector_add.cpp" -o /tmp/vector_add
else
    $CXX -fsycl -O2 "$SCRIPT_DIR/vector_add.cpp" -o /tmp/vector_add
fi

echo ""
echo "=== Test 1: Default backend ==="
OUTPUT=$(/tmp/vector_add 2>&1)
echo "$OUTPUT"
if echo "$OUTPUT" | grep -q "PASS"; then
    # For Intel containers, verify it's NOT using PoCL by default
    if [ -f /opt/pocl/lib/libpocl.so.2 ]; then
        if echo "$OUTPUT" | grep -q "Device: cpu-"; then
            echo "Test 1: FAILED - Expected Intel OpenCL but got PoCL"
            FAILED=1
        else
            echo "Test 1: PASSED (Intel OpenCL)"
        fi
    else
        echo "Test 1: PASSED"
    fi
else
    echo "Test 1: FAILED"
    FAILED=1
fi

# Test PoCL backend if available (intel-sycl containers only)
if [ -f /opt/pocl/lib/libpocl.so.2 ]; then
    echo ""
    echo "=== Test 2: PoCL backend ==="
    export OCL_ICD_FILENAMES=/opt/pocl/lib/libpocl.so.2
    export SYCL_DEVICE_ALLOWLIST=''
    OUTPUT=$(/tmp/vector_add 2>&1)
    echo "$OUTPUT"
    if echo "$OUTPUT" | grep -q "PASS"; then
        if echo "$OUTPUT" | grep -q "Device: cpu-"; then
            echo "Test 2: PASSED (PoCL)"
        else
            echo "Test 2: FAILED - Expected PoCL but got different backend"
            FAILED=1
        fi
    else
        echo "Test 2: FAILED"
        FAILED=1
    fi
    unset OCL_ICD_FILENAMES SYCL_DEVICE_ALLOWLIST
fi

echo ""
if [ $FAILED -eq 0 ]; then
    echo "All tests passed!"
else
    echo "Some tests failed!"
    exit 1
fi
