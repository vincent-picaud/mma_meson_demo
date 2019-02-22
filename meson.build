project('Meson_MMA_Demo', 'cpp')

mma_wolframscript = find_program('wolfram')

maa_config = run_command(mma_wolframscript,'-script',files('config.wls'),
			check: true)

# if not maa_config.check()
#   error('An error occurred running config.wls', 'cannot configure directories')
# endif

maa_config = maa_config.stdout().split(';')

mma_include_directories = include_directories(maa_config.get(0).split(','))
mma_library_install_dir = maa_config.get(1).strip() # caveat: strip is mandatory to get 
mma_package_install_dir = maa_config.get(2).strip() # a correct filename

message('MMA library installation directory: '+mma_library_install_dir)
message('MMA package installation directory: '+mma_package_install_dir)

subdir('src')

