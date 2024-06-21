# Use an official Ubuntu 24.04 LTS as a parent image
FROM ubuntu:24.04

# Set environment variables to non-interactive (this avoids some prompts)
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages and add LLVM repository
RUN apt-get update && apt-get install -y wget gnupg software-properties-common \
    && wget https://apt.llvm.org/llvm.sh \
    && chmod +x llvm.sh \
    && ./llvm.sh 17 \
    && apt-get install -y \
    build-essential \
    cmake \
    git \
    libstdc++6 \
    libboost-all-dev \
    python3-pip \
    clang-17 \
    libclang-17-dev \
    llvm-17 \
    llvm-17-dev \
    libomp-17-dev \
    ninja-build \ 
    && rm -rf /var/lib/apt/lists/*

# Set clang and llvm-config binaries to the installed version
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-17 100 \
    && update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-17 100

# Clone the AdaptiveCpp repository
RUN git clone --depth 1 --branch v24.02.0 https://github.com/illuhad/hipSYCL.git /hipsycl

# Set the working directory to the hipSYCL directory
WORKDIR /hipsycl

# Create a build directory
RUN mkdir build

# Configure the project with CMake
RUN cmake -S . -B build \
    -DCMAKE_INSTALL_PREFIX=/opt/hipsycl \
    -DCMAKE_BUILD_TYPE=Release \
    -DWITH_CPU_BACKEND=ON \
    -DWITH_CUDA_BACKEND=OFF \
    -DWITH_ROCM_BACKEND=OFF \
    -DLLVM_DIR=/usr/lib/llvm-17 \
    -DCLANG_EXECUTABLE_PATH=/usr/bin/clang++-17

# Build and install
RUN cmake --build build --target install

# Setting environment variables for AdaptiveCpp
ENV HIPSYCL_INSTALL_DIR=/opt/hipsycl
ENV PATH="${HIPSYCL_INSTALL_DIR}/bin:${PATH}"
ENV CPATH="${HIPSYCL_INSTALL_DIR}/include:${CPATH}"
ENV LD_LIBRARY_PATH="${HIPSYCL_INSTALL_DIR}/lib:${LD_LIBRARY_PATH}"
ENV LIBRARY_PATH="${HIPSYCL_INSTALL_DIR}/lib:${LIBRARY_PATH}"
ENV CC=cc
ENV CXX=acpp

# Set the default command to bash
CMD ["bash"]
