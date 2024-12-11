#pragma once
#include <cstddef>
namespace util
{

inline double calculate_variance(double value, double mean, size_t count)
{
    return (value - mean) * (value - mean) / count;
}

} // namespace util
