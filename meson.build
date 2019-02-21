project('Meson_MMA_Demo', 'cpp')

mma_wolframscript = find_program('wolframscript')


# TODO: do that programmatically
mma_include_directories = include_directories(['/usr/local/Wolfram/Mathematica/11.2/SystemFiles/IncludeFiles/C'])
mma_library_install_dir = '/home/picaud/.Mathematica/SystemFiles/LibraryResources/Linux-x86-64'
mma_package_install_dir = '/home/picaud/.Mathematica/Applications'
subdir('src')

