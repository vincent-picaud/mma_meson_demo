project('Meson_MMA_Demo', 'cpp')

mma_wolframscript = find_program('wolfram')
#mma_wolframscript = find_program('wolframscript')


# TODO: do that programmatically
# mma_include_directories = include_directories(['/usr/local/Wolfram/Mathematica/11.2/SystemFiles/IncludeFiles/C'])
# mma_library_install_dir = '/home/picaud/.Mathematica/SystemFiles/LibraryResources/Linux-x86-64'
# mma_package_install_dir = '/home/picaud/.Mathematica/Applications'

maa_config = run_command(mma_wolframscript,'-script',files('config.wls')).stdout().split(';')
#maa_config = run_command(mma_wolframscript,'-print','-code','Import[FileNameJoin[{Environment["MESON_SOURCE_ROOT"],"config.wls"}]]')

mma_include_directories = include_directories(maa_config.get(0).split(','))
mma_library_install_dir = maa_config.get(1).strip() # caveat: strip is mandatory to get 
mma_package_install_dir = maa_config.get(2).strip() # a correct filename

# assert(mma_package_install_dir=='/home/picaud/.Mathematica/Applications','aie')

message('MMA library installation directory: '+mma_library_install_dir)
message('MMA package installation directory: '+mma_package_install_dir)

subdir('src')

