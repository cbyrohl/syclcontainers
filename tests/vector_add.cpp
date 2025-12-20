#include <sycl/sycl.hpp>
#include <iostream>
#include <vector>

int main() {
    const int N = 1024;
    std::vector<int> a(N, 1), b(N, 2), c(N, 0);

    sycl::queue q;
    std::cout << "Device: " << q.get_device().get_info<sycl::info::device::name>() << std::endl;

    {
        sycl::buffer<int> buf_a(a.data(), sycl::range<1>(N));
        sycl::buffer<int> buf_b(b.data(), sycl::range<1>(N));
        sycl::buffer<int> buf_c(c.data(), sycl::range<1>(N));

        q.submit([&](sycl::handler& h) {
            auto acc_a = buf_a.get_access<sycl::access::mode::read>(h);
            auto acc_b = buf_b.get_access<sycl::access::mode::read>(h);
            auto acc_c = buf_c.get_access<sycl::access::mode::write>(h);

            h.parallel_for<class vector_add>(sycl::range<1>(N), [=](sycl::id<1> i) {
                acc_c[i] = acc_a[i] + acc_b[i];
            });
        });
    }

    bool success = true;
    for (int i = 0; i < N; i++) {
        if (c[i] != 3) { success = false; break; }
    }

    std::cout << (success ? "PASS" : "FAIL") << std::endl;
    return success ? 0 : 1;
}
