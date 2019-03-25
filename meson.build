#----------------
# Regular Meson C++ project
#----------------
project('Meson_MMA_Demo', 'cpp')

subdir('src')

#----------------
# MMA specific
#----------------
mma_wolframscript = find_program('wolframscript')

if mma_wolframscript.found()
  subdir('mma')
else
  warning('Mathematica not found!')
endif

