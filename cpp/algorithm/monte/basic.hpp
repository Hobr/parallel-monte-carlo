#pragma once
#include "../../util/random.hpp"
#include "../../util/statistics.hpp"
#include "../../util/timer.hpp"

namespace monte
{
class Basic
{
  public:
    struct Params
    {
        size_t samples;
        double radius;
        bool simd;
        bool vectorized;
    };

    Basic(const Params &params)
    {
    }
    virtual ~Basic() = default;

    virtual void run()
    {
    }

    const util::Statistics &get_results() const
    {
        return stats_;
    }

  protected:
    Params params_;
    util::Statistics stats_;
};
} // namespace monte
