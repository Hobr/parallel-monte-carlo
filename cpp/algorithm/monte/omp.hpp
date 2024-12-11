#pragma once
#include "basic.hpp"

namespace monte
{
class Omp : public Basic
{
  public:
    using Basic::Basic;
    void run() override;
};
} // namespace monte
