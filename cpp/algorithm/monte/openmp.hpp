#pragma once
#include "../../util/random.hpp"
#include "../../util/type.hpp"
#include <omp.h>

namespace mc
{

class BasicMonteCarloOMP
{
  public:
    explicit BasicMonteCarloOMP(const Config &config) : config_(config)
    {
    }

    Statistics simulate()
    {
        auto start_wall = std::chrono::high_resolution_clock::now();
        auto start_cpu = std::clock();

        double sum = 0.0;
        double sum_sq = 0.0;

#pragma omp parallel reduction(+ : sum, sum_sq)
        {
            // 每个线程独立的随机数生成器
            RandomGenerator local_rng(config_);

#pragma omp for
            for (size_t i = 0; i < config_.samples; ++i)
            {
                double x = local_rng.generate() * 2.0 - 1.0;
                double y = local_rng.generate() * 2.0 - 1.0;

                if (x * x + y * y <= config_.radius * config_.radius)
                {
                    sum += 1.0;
                    sum_sq += 1.0;
                }
            }
        }

        auto end_wall = std::chrono::high_resolution_clock::now();
        auto end_cpu = std::clock();

        Statistics stats;
        // ... (统计计算与基础版本相同)

        // 计算OpenMP加速比
        stats.speedup = stats.cpu_time / stats.wall_time;

        return stats;
    }

  private:
    Config config_;
};

} // namespace mc
