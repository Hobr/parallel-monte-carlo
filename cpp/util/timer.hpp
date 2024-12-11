#pragma once
#include <chrono>

class Timer
{
  public:
    void start()
    {
        start_time = std::chrono::high_resolution_clock::now();
    }
    void stop()
    {
        end_time = std::chrono::high_resolution_clock::now();
    }

    double wall_time() const
    {
        return std::chrono::duration<double>(end_time - start_time).count();
    }

    double cpu_time() const
    {
        return wall_time();
    }

  private:
    std::chrono::time_point<std::chrono::high_resolution_clock> start_time, end_time;
};
