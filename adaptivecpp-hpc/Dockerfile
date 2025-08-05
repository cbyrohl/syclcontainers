# Use the custom base image
FROM ghcr.io/cbyrohl/adaptivecpp-base:main

# Install HDF5 and OpenMPI
RUN apt-get update && apt-get install -y \
    libhdf5-dev \
    libhdf5-serial-dev \
    hdf5-tools \
    openmpi-bin \
    libopenmpi-dev \
    libgmp-dev \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables, if necessary
# For example, you might want to configure paths for MPI and HDF5
ENV PATH="/usr/lib/openmpi/bin:${PATH}"

# Command to keep the container running (optional)
CMD ["bash"]
