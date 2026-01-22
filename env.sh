#!/usr/bin/env bash

# Usage: source env.sh

# ============================================================================ #
# Set up environment variables for the project
# ============================================================================ #
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FPGA_DIR="$ROOT_DIR/fpga"
FPGA_BUILD_DIR="$ROOT_DIR/build/fpga"
SIM_BUILD_DIR="$ROOT_DIR/build/sim"
RESULTS_DIR="$ROOT_DIR/results"
PATH="$ROOT_DIR/tools:$PATH"

# ============================================================================ #
# Export environment variables
# ============================================================================ #
export ROOT_DIR
export FPGA_DIR
export FPGA_BUILD_DIR
export SIM_BUILD_DIR
export RESULTS_DIR
export PATH
