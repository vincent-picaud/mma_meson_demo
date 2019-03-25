myLib_headers = ['algorithm1.hpp']
myLib_sources = ['algorithm1.cpp']

myLib_lib = library('myLib',
		   include_directories : inc,
		   install : true,
		   sources: [myLib_headers,myLib_sources])

myLib_dep = declare_dependency(include_directories : inc,
			      link_with : myLib_lib)

install_headers(myLib_headers,
		subdir : 'myLib')

