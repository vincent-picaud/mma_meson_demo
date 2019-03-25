#include "myLib/algorithm1.hpp"

namespace myLib
{
  void algorithm1(const double alpha, const double* source, double* dest, const size_t n)
  {
    for (size_t i = 0; i < n; i++)
    {
      dest[i] = alpha*source[i];
    }
  }

}  // namespace myLib
