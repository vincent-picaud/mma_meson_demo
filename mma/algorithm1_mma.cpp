#include <cassert>
#include <iostream>

#include "WolframLibrary.h"
#include "WolframSparseLibrary.h"

#include "myLib/algorithm1.hpp"

//----------------

// TODO replace asserts by MMA error message
extern "C" DLLEXPORT int algorithm1(WolframLibraryData libData, mint Argc, MArgument* Args, MArgument Res)
{
  // alpha
  const double alpha = MArgument_getReal(Args[0]);
  // source vector
  const MTensor src_tensor = MArgument_getMTensor(Args[1]);
  assert(libData->MTensor_getType(src_tensor)==MType_Real);
  const mint src_rank = libData->MTensor_getRank(src_tensor);
  assert(src_rank == 1);
  const mint* const src_dims = libData->MTensor_getDimensions(src_tensor);
  const double* const src_data = libData->MTensor_getRealData(src_tensor);
  // dest vector
  MTensor dest_tensor;
  const mint dest_rank = src_rank;
  const mint dest_dims[] = { src_dims[0] };
  libData->MTensor_new(MType_Real, dest_rank, dest_dims, &dest_tensor);
  double* const dest_data = libData->MTensor_getRealData(dest_tensor);

  // call our libmyLib.so function 
  myLib::algorithm1(alpha,src_data,dest_data,src_dims[0]);
  
  MArgument_setMTensor(Res, dest_tensor);
  return LIBRARY_NO_ERROR;
}

