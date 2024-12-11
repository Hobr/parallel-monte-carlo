#pragma once
#include "basic.hpp"
// #include <mpi.h>

namespace monte
{
class Mpi : public Basic
{
  public:
    using Basic::Basic;
    void run() override;

  private:
    void distribute_tasks();
    void gather_results();
};
} // namespace monte
