#pragma once
#include "../../util/statistics.hpp"
#include "../../util/timer.hpp"
#include <random>

namespace monte::adaptive
{

class AdaptiveSampling
{
  public:
    struct Result
    {
        double result;
        double variance;
        double wall_time;
        double cpu_time;
    };

    Result compute(size_t samples, double radius, std::mt19937 &random_engine);
};

} // namespace monte::adaptive
