# Note: Using Ubuntu base instead of intel/oneapi-hpckit (~10-15 GB) which is too large for GitHub Actions runners
FROM ubuntu:24.04

# Set environment variables to non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Install Intel oneAPI repository and only the SYCL compiler components
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    software-properties-common \
    && wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | gpg --dearmor | tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | tee /etc/apt/sources.list.d/oneAPI.list \
    && apt-get update \
    && apt-get install -y \
    build-essential \
    git \
    gdb \
    cmake \
    ninja-build \
    libboost-all-dev \
    python3-pip \
    intel-oneapi-compiler-dpcpp-cpp-2025.0 \
    intel-oneapi-mkl-devel-2025.0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

# Set up Intel oneAPI environment variables
ENV ONEAPI_ROOT=/opt/intel/oneapi
ENV CMPLR_ROOT=${ONEAPI_ROOT}/compiler/latest
ENV PATH=${CMPLR_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${CMPLR_ROOT}/lib:${LD_LIBRARY_PATH}
ENV CPATH=${CMPLR_ROOT}/include:${CPATH}
ENV LIBRARY_PATH=${CMPLR_ROOT}/lib:${LIBRARY_PATH}

# Set Intel compilers as default
ENV CC=icx
ENV CXX=icpx

# Set the default command to bash
CMD ["bash"]
