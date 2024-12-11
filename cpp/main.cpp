#include "algorithm/adaptive.hpp"
#include "algorithm/importance.hpp"
#include "algorithm/monte.hpp"
#include "algorithm/quasi.hpp"
#include "algorithm/stratified.hpp"
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
