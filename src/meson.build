demo_sparse_sources = ['demo_sparse.cpp']

shared_library('demo_sparse',
	       sources: [demo_sparse_sources],
	       include_directories: mma_include_directories,
	       install: true,
	       install_dir: mma_library_install_dir)


# CAVEAT: mma package name must not include '_', hence this is
#         certainly a better option to use this Camel case convention
#         even for C/C++ files (not the case here, see demo_sparse.cpp)
install_data('sparseDemoPackage.wl',
	     install_dir: mma_package_install_dir )
	     
