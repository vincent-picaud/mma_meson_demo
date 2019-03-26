#----------------
# Extract MMA information 
#----------------

# try MMA v10 first
mma_wolframscript = find_program('MathematicaScript')
if mma_wolframscript.found()
  maa_config = run_command(mma_wolframscript,'-script',files('config.wls'), check: true)
else
  # then MMA v11
  mma_wolframscript = find_program('wolframscript')
  if mma_wolframscript.found()
    maa_config = run_command(mma_wolframscript,'-f',files('config.wls'), check: true)
  else
    # no MMA? 
    warning('Mathematica not found!')
    subdir_done()
  endif
endif
    
maa_config = maa_config.stdout().split(';')

mma_include_directories = include_directories(maa_config.get(0).split(','))
mma_library_install_dir = maa_config.get(1).strip() # caveat: strip is mandatory to get 
mma_package_install_dir = maa_config.get(2).strip() # a correct filename

message('MMA library installation directory: '+mma_library_install_dir)
message('MMA package installation directory: '+mma_package_install_dir)

#----------------
# myLibMMA library 
#----------------

myLibMMA_sources = ['myLib_mma.cpp',
		    'algorithm1_mma.cpp']

shared_library('myLibMMA',
	       sources: [myLibMMA_sources],
	       dependencies: [myLib_dep],
	       include_directories: mma_include_directories,
	       install: true,
	       # libmyLibMMA.so needs to find libmyLib.so, this can be done using rpath
	       install_rpath: join_paths(get_option('prefix'),get_option('libdir')),
	       install_dir: mma_library_install_dir)

#----------------
# MMA package
#----------------

install_data('myLib.wl', install_dir: mma_package_install_dir )
