#include <cassert>
#include <iostream>

#include "WolframLibrary.h"
#include "WolframSparseLibrary.h"

#include "myLib/algorithm1.hpp"

//----------------

extern "C" DLLEXPORT int algorithm1(WolframLibraryData libData, mint Argc, MArgument* Args, MArgument Res)
{
  const MTensor src_tensor = MArgument_getMTensor(Args[0]);
  const mint src_rank = libData->MTensor_getRank(src_tensor);
  assert(src_rank == 1);
  const mint* const src_dims = libData->MTensor_getDimensions(src_tensor);
  const double* const src_data = libData->MTensor_getRealData(src_tensor);
  //  const mint halfWidth = MArgument_getInteger(Args[1]);

  MTensor dest_tensor;
  const mint dest_rank = 1;
  const mint dest_dims[] = { src_dims[0] };
  libData->MTensor_new(MType_Real, dest_rank, dest_dims, &dest_tensor);
  double* const dest_data = libData->MTensor_getRealData(dest_tensor);

  size_t size = src_dims[0];
  for (size_t i = 0; i < size; i++)
  {
    std::cerr << "\n -----------" << src_data[i];
    dest_data[i] = -3 * src_data[i];
  }

  std::cerr << "\n ----------- qsdfqsdf";

  MArgument_setMTensor(Res, dest_tensor);
  return LIBRARY_NO_ERROR;
}

