# Use the custom Intel SYCL base image
FROM ghcr.io/cbyrohl/intel-sycl-base:main

# Set environment variables to non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Install HDF5 and additional HPC libraries
# Note: Intel MPI is already included in the oneAPI HPC Kit base image
RUN apt-get update && apt-get install -y \
    libhdf5-dev \
    libhdf5-serial-dev \
    hdf5-tools \
    libgmp-dev \
    && rm -rf /var/lib/apt/lists/*

# Command to keep the container running
CMD ["bash"]
