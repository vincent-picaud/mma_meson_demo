#include "myLib/algorithm1.hpp"

namespace myLib
{
  void algorithm1(const double* source, double* dest, const size_t n, const size_t halfWidth)
  {
    for (size_t i = 0; i < n; i++)
    {
      dest[i] = source[i];
    }
  }

}  // namespace myLib
