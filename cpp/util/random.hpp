// include/common/random.hpp
#pragma once

#include "type.hpp"

#ifdef USE_MKL
#include <mkl.h>
#endif

namespace mc
{

class RandomGenerator
{
  public:
    explicit RandomGenerator(const Config &config) : config_(config), mt_(std::random_device{}()), dist_(0.0, 1.0)
    {
    }

    // 单个
    double generate()
    {
        if (config_.random_type == Config::RandomType::STD)
        {
            return dist_(mt_);
        }
#ifdef USE_MKL
        else
        {
            double result;
            vdRngUniform(VSL_RNG_METHOD_UNIFORM_STD, stream_, 1, &result, 0.0, 1.0);
            return result;
        }
#endif
        return 0.0;
    }

    // 多个
    std::vector<double> generate_batch(size_t n)
    {
        std::vector<double> results(n);
        if (config_.random_type == Config::RandomType::STD)
        {
            for (size_t i = 0; i < n; ++i)
            {
                results[i] = dist_(mt_);
            }
        }
#ifdef USE_MKL
        else
        {
            vdRngUniform(VSL_RNG_METHOD_UNIFORM_STD, stream_, n, results.data(), 0.0, 1.0);
        }
#endif
        return results;
    }

  private:
    Config config_;
    std::mt19937 mt_;
    std::uniform_real_distribution<double> dist_;
#ifdef USE_MKL
    VSLStreamStatePtr stream_;
#endif
};

} // namespace mc
