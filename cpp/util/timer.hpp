#pragma once
#include <chrono>

namespace util
{
class Timer
{
  public:
    void start();
    void stop();
    double elapsed() const;

  private:
    std::chrono::high_resolution_clock::time_point start_time_, end_time_;
};
} // namespace util
