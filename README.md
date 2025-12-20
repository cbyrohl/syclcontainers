Docker containers for SYCL implementations.

## AdaptiveCpp Containers

* **adaptivecpp-base**: Base AdaptiveCpp container with CPU backend
* **adaptivecpp-hpc**: AdaptiveCpp with HDF5 and OpenMPI

## Intel SYCL Containers

* **intel-sycl-base**: Base Intel DPC++ container with Intel oneAPI HPC Toolkit
* **intel-sycl-hpc**: Intel DPC++ with HDF5 and Intel MPI

### OpenCL Backend Selection (intel-sycl-base)

The container includes both Intel OpenCL and PoCL backends. Intel OpenCL is used by default.

```bash
# Use Intel OpenCL (default)
./my_sycl_app

# Use PoCL instead
export OCL_ICD_FILENAMES=/opt/pocl/lib/libpocl.so.2
export SYCL_DEVICE_ALLOWLIST=''
./my_sycl_app

# List available devices
sycl-ls
```

## Testing

Run the test suite inside a container:

```bash
# Intel containers
docker run --rm -v ./tests:/tests intel-sycl-base bash -c "source /opt/intel/oneapi/setvars.sh && /tests/run_tests.sh"

# AdaptiveCpp containers
docker run --rm -v ./tests:/tests adaptivecpp-base /tests/run_tests.sh
```
