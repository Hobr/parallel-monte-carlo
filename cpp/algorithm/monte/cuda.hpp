#pragma once
#include "basic.hpp"
// #include <cuda_runtime.h>

namespace monte
{
class Cuda : public Basic
{
  public:
    using Basic::Basic;
    void run() override;

  private:
    void allocate_device_memory();
    void free_device_memory();
};
} // namespace monte
