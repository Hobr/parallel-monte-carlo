#pragma once
#include "../../util/random.hpp"
#include "../../util/type.hpp"

namespace mc
{

class BasicMonteCarlo
{
  public:
    explicit BasicMonteCarlo(const Config &config) : config_(config), rng_(config)
    {
    }

    Statistics simulate()
    {
        auto start_wall = std::chrono::high_resolution_clock::now();
        auto start_cpu = std::clock();

        double sum = 0.0;
        double sum_sq = 0.0;

        for (size_t i = 0; i < config_.samples; ++i)
        {
            double x = rng_.generate() * 2.0 - 1.0;
            double y = rng_.generate() * 2.0 - 1.0;

            if (x * x + y * y <= config_.radius * config_.radius)
            {
                sum += 1.0;
                sum_sq += 1.0;
            }
        }

        auto end_wall = std::chrono::high_resolution_clock::now();
        auto end_cpu = std::clock();

        Statistics stats;
        stats.result = 4.0 * sum / config_.samples; // π的估计值
        stats.wall_time = std::chrono::duration<double>(end_wall - start_wall).count();
        stats.cpu_time = static_cast<double>(end_cpu - start_cpu) / CLOCKS_PER_SEC;

        // 计算方差
        double mean = sum / config_.samples;
        stats.variance = (sum_sq / config_.samples - mean * mean);

        // 计算95%置信区间
        stats.confidence = 1.96 * std::sqrt(stats.variance / config_.samples);

        // 精度（与真实π值的相对误差）
        stats.accuracy = std::abs(stats.result - M_PI) / M_PI;

        // 收敛性（样本量的倒数）
        stats.convergence = 1.0 / std::sqrt(config_.samples);

        // CPU利用率
        stats.utilization = stats.cpu_time / stats.wall_time;

        // 单线程下加速比为1
        stats.speedup = 1.0;

        return stats;
    }

  private:
    Config config_;
    RandomGenerator rng_;
};

} // namespace mc
