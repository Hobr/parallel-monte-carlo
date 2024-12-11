#pragma once
#include <mkl.h>
#include <random>

namespace util
{
class Random
{
  public:
    enum class EngineType
    {
        Std,
        MKL
    };

    Random(EngineType type, uint64_t seed);
    ~Random();
    double next();

  private:
    EngineType type_;
    std::mt19937 std_engine_;
    VSLStreamStatePtr mkl_engine_;
};
} // namespace util
