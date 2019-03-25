#include "WolframLibrary.h"
#include "WolframSparseLibrary.h"

extern "C" DLLEXPORT mint WolframLibrary_getVersion() { return WolframLibraryVersion; }
extern "C" DLLEXPORT int WolframLibrary_initialize(WolframLibraryData libData) { return LIBRARY_NO_ERROR; }
extern "C" DLLEXPORT void WolframLibrary_uninitialize(WolframLibraryData libData) { return; }
