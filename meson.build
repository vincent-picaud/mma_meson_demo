project('Meson_MMA_Demo', 'cpp')

mma_wolframscript = find_program('wolframscript')


# TODO: do that programmatically
# mma_include_directories = include_directories(['/usr/local/Wolfram/Mathematica/11.2/SystemFiles/IncludeFiles/C'])
# mma_library_install_dir = '/home/picaud/.Mathematica/SystemFiles/LibraryResources/Linux-x86-64'
# mma_package_install_dir = '/home/picaud/.Mathematica/Applications'

maa_config = run_command(mma_wolframscript,'-print','-code','Import[FileNameJoin[{Environment["MESON_SOURCE_ROOT"],"config.wls"}]]')

var=maa_config.stdout().split(',')
message(var)
mma_include_directories = include_directories(var.get(0))
mma_library_install_dir = '/home/picaud/.Mathematica/SystemFiles/LibraryResources/Linux-x86-64'
mma_package_install_dir = '/home/picaud/.Mathematica/Applications'

message(maa_config.stdout())
message(mma_include_directories)

#test = command FileNameJoin[{$UserBaseDirectory, "Applications"}]

test = [ [ ['A','B'], '12' ], [ '45' ] ]
message(test.get(0).get(0).get(1))
message(test.get(1))
message(test.length())

subdir('src')

