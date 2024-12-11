#pragma once
#include "../../util/statistics.hpp"
#include "../../util/timer.hpp"
#include <random>

namespace monte::basic
{

struct Result
{
    double result;
    double variance;
    double wall_time;
    double cpu_time;
};

class MonteCarloBasic
{
  public:
    virtual ~MonteCarloBasic() = default;
    virtual Result compute(size_t samples, double radius, std::mt19937 &random_engine) = 0;
};

class GeneralMonteCarlo : public MonteCarloBasic
{
  public:
    Result compute(size_t samples, double radius, std::mt19937 &random_engine) override;
};

class BatchMonteCarlo : public MonteCarloBasic
{
  public:
    Result compute(size_t samples, double radius, std::mt19937 &random_engine) override;
};

class SymmetryMonteCarlo : public MonteCarloBasic
{
  public:
    Result compute(size_t samples, double radius, std::mt19937 &random_engine) override;
};

} // namespace monte::basic
