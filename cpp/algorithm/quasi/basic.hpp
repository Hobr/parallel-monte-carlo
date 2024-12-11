#pragma once
#include "../../util/statistics.hpp"
#include "../../util/timer.hpp"
#include <random>

namespace monte::quasi
{

class SobolSequence
{
  public:
    struct Result
    {
        double result;
        double variance;
        double wall_time;
        double cpu_time;
    };

    Result compute(size_t samples, double radius);
};

class HaltonSequence
{
  public:
    struct Result
    {
        double result;
        double variance;
        double wall_time;
        double cpu_time;
    };

    Result compute(size_t samples, double radius);
};

class FaureSequence
{
  public:
    struct Result
    {
        double result;
        double variance;
        double wall_time;
        double cpu_time;
    };

    Result compute(size_t samples, double radius);
};

} // namespace monte::quasi
