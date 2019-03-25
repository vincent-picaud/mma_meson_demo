# This is a minimal example showing how to integrate C++ and Mathematica's LibraryLink
# Tested under MMA V11.2, Linux
#
project('Meson_MMA_Demo', 'cpp')

subdir('src')

# MMA part 
mma_wolframscript = find_program('wolframscript')

if mma_wolframscript.found()
  subdir('mma')
else
  warning('Mathematica not found!')
endif

