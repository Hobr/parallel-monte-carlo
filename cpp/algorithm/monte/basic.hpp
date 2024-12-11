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

    Basic(const Params &params);
    virtual void run();
    const util::Statistics &get_results() const;

  private:
    Params params_;
    util::Statistics stats_;
};
} // namespace monte
