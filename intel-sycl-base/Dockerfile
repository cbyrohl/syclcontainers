# Use Intel oneAPI HPC Toolkit as base image
FROM docker.io/intel/oneapi-hpckit:2025.3.0-0-devel-ubuntu22.04

# Set environment variables to non-interactive (this avoids some prompts)
ENV DEBIAN_FRONTEND=noninteractive

# Install additional development tools to match adaptivecpp-base
# Note: Intel oneAPI devel image already includes build-essential, gdb, and basic tools
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    ninja-build \
    libboost-all-dev \
    python3-pip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set Intel compilers as default
# Note: Intel oneAPI environment is already initialized in the base image
ENV CC=icx
ENV CXX=icpx

# Set the default command to bash
CMD ["bash"]
