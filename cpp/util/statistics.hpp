#pragma once
#include <vector>

namespace util
{
struct Result
{
    double value;
    double accuracy;
    double wall_time;
    double cpu_time;
    double variance;
    double convergence;
    double confidence;
    double utilization;
    double amdahl;
};

class Statistics
{
  public:
    void add_result(const Result &result);
    const std::vector<Result> &get_results() const;

  private:
    std::vector<Result> results_;
};
} // namespace util
