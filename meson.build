project('Meson_MMA_Demo', 'cpp')

mma_wolframscript = find_program('wolframscript')


# TODO: do that programmatically
# mma_include_directories = include_directories(['/usr/local/Wolfram/Mathematica/11.2/SystemFiles/IncludeFiles/C'])
# mma_library_install_dir = '/home/picaud/.Mathematica/SystemFiles/LibraryResources/Linux-x86-64'
# mma_package_install_dir = '/home/picaud/.Mathematica/Applications'

maa_config = run_command(mma_wolframscript,'-print','-code','Import[FileNameJoin[{Environment["MESON_SOURCE_ROOT"],"config.wls"}]]')
# message(maa_config.stdout())
# maa_config = run_command('cd',meson.build_root(),';','cat','libraryLinkIncludeDirectories.conf')
# message(maa_config.stdout())
# subdir_done()

var=maa_config.stdout().split(';')
message(var)
message(var.get(0).split(','))
message(var.get(1))
message(var.get(2))
subdir_done()
mma_include_directories = include_directories(var.get(0).split(','))
mma_library_install_dir = '/home/picaud/.Mathematica/SystemFiles/LibraryResources/Linux-x86-64'
mma_package_install_dir = '/home/picaud/.Mathematica/Applications'

message(mma_include_directories)

#test = command FileNameJoin[{$UserBaseDirectory, "Applications"}]

test = [ [ ['A','B'], '12' ], [ '45' ] ]
message(test.get(0).get(0).get(1))
message(test.get(1))
message(test.length())

subdir('src')

