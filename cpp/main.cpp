#include "algorithm/monte/basic.hpp"
#include "algorithm/monte/cuda.hpp"
#include "algorithm/monte/mpi.hpp"
#include "algorithm/monte/omp.hpp"
#include <iostream>

int main()
{
    monte::Basic::Params params{.samples = 1000000, .radius = 1.0, .simd = false, .vectorized = false};

    monte::Basic basic(params);
    basic.run();
    const auto &results = basic.get_results().get_results();

    for (const auto &result : results)
    {
        std::cout << "Value: " << result.value << "\n";
        std::cout << "Accuracy: " << result.accuracy << "\n";
    }

    return 0;
}
