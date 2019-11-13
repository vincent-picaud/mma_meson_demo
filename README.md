
# Table of Contents

1.  [What is it?](#orgd7c8dd9)
2.  [News](#org914de66)
3.  [How to use it?](#orgbd12062)
    1.  [Compile and install the package](#org92629d1)
    2.  [Mathematica side](#orgcf3d7bb)
4.  [Portability](#org0f5d23a)
5.  [How it works?](#orga5b76b3)
    1.  [`meson.build`](#org7b74380)
    2.  [`./src/meson.build`](#orgcc63643)
        1.  [`./src/myLib/meson.build`](#org0970777)
    3.  [`./mma/meson.build`](#org52641b3)
    4.  [`config.wls`](#orgd9f27f6)
    5.  [Our cpp files](#org185c8c7)
        1.  [The `libmyLib.so` cpp files (our c++ library)](#org60a137d)
        2.  [The `libmyLibMMA.so` cpp files (our MMA wrapper)](#orgc6c94c2)
6.  [Useful references](#org4bde0a1)



<a id="orgd7c8dd9"></a>

# What is it?

The goal is to use the [Meson build system](https://mesonbuild.com/) to define an **easy to use** and
**portable** solution for Mathematica (MMA) [Wolfram LibraryLink
developments](https://reference.wolfram.com/language/LibraryLink/tutorial/InteractionWithMathematica.html). This GitHub repository is a small illustrative example.

The important files are:

    + meson.build
    + mma/
    	+ algorithm1_mma.cpp
    	+ config.wls
    	+ meson.build
    	+ myLib_mma.cpp
    	+ myLib.wl
    + src/
    	+ meson.build
    	+ myLib/
    		+ algorithm1.cpp
    		+ algorithm1.hpp
    		+ meson.build


<a id="org914de66"></a>

# News

-   <span class="timestamp-wrapper"><span class="timestamp">&lt;Tue Mar 26 2019&gt;</span></span> added support for MMA v10 (before only v11 was supported)


<a id="orgbd12062"></a>

# How to use it?


<a id="org92629d1"></a>

## Compile and install the package

    git clone git@github.com:vincent-picaud/mma_meson_demo.git
    cd mma_meson_demo
    meson build --prefix=$(pwd)/install_dir
    cd build
    ninja install

you will get something like:

    picaud@hostname:~/GitHub/mma_meson_demo$ meson build --prefix=$(pwd)/install_dir
    The Meson build system
    Version: 0.49.2
    Source dir: /home/picaud/GitHub/mma_meson_demo
    Build dir: /home/picaud/GitHub/mma_meson_demo/build
    Build type: native build
    Project name: Meson_MMA_Demo
    Project version: undefined
    Native C++ compiler: ccache c++ (gcc 8.3.0 "c++ (Debian 8.3.0-2) 8.3.0")
    Build machine cpu family: x86_64
    Build machine cpu: x86_64
    Program wolframscript found: YES (/usr/bin/wolframscript)
    Message: MMA library installation directory: /home/picaud/.Mathematica/SystemFiles/LibraryResources/Linux-x86-64
    Message: MMA package installation directory: /home/picaud/.Mathematica/Applications
    Build targets in project: 2
    Found ninja-1.8.2 at /usr/bin/ninja
    picaud@hostname:~/GitHub/mma_meson_demo$ cd build/
    picaud@hostname:~/GitHub/mma_meson_demo/build$ ninja install
    [5/6] Installing files.
    Installing src/myLib/libmyLib.so to /home/picaud/GitHub/mma_meson_demo/install_dir/lib/x86_64-linux-gnu
    Installing mma/libmyLibMMA.so to /home/picaud/.Mathematica/SystemFiles/LibraryResources/Linux-x86-64
    Installing /home/picaud/GitHub/mma_meson_demo/src/myLib/algorithm1.hpp to /home/picaud/GitHub/mma_meson_demo/install_dir/include/myLib
    Installing /home/picaud/GitHub/mma_meson_demo/mma/myLib.wl to /home/picaud/.Mathematica/Applications

> **Remark**: [role of &#x2013;prefix]
> 
> This demo will generate two dynamic libraries:
> 
> -   `libmyLib.so` a regular C++ library (totally independent of MMA)
> -   `libmylibMMA.so` a dynamic library that uses MMA's LibraryLink to wrap functions contained in `libmyLib.so`.
> 
> The `libmyLib.so` install directory is defined by the `--prefix` flag, with `--prefix=$(pwd)/install_dir` this is
> 
>     /home/picaud/GitHub/mma_meson_demo/install_dir/lib/x86_64-linux-gnu
> 
> in my case.
> 
> By default `libmylibMMA.so` is installed in the user directory
> 
>     $HOME/.Mathematica/SystemFiles/LibraryResources/Linux-x86-64
> 
> in my case.
> 
> The important point to understand is that `libmylibMMA.so` needs to know
> where the `libmyLib.so` library is installed. We provide this
> information by embedding it into the `libmylibMMA.so` [`rpath`
> section](https://amir.rachum.com/blog/2016/09/17/shared-libraries/). This section is [filled by Meson](https://mesonbuild.com/Reference-manual.html#executable) at **installation** time. By
> consequence to make it works we must define this installation path.
> 
> If the `--prefix` variable is not defined everything works equally well
> except that you will need extra permissions to do a default **system**
> install (invoked when you type `ninja install`).


<a id="orgcf3d7bb"></a>

## Mathematica side

To test it works, type the following under Mathematica:

    << myLib`
    
    ?"myLib`*"
    data = {2, 1, 3, 5, 6, 6, 4, 3 };
    algorithm1[100.,data]

it should print:

    algorithm1[α_Real,vector_?VectorQ] returns α.vector
    
    {200., 100., 300., 500., 600., 600., 400., 300.}

> **Remark**: [ ``myLib`Private`unload[]`` ]
> 
> If you recompile the `libmylib.so` or `libmylibMMA.so` C++ library you
> must call ``myLib`Private`unload[]`` to make MMA aware of this
> modification (no need to kill the Kernel!).
> 
> Obviously, for regular uses of the MMA `myLib` package, you do not need
> this function.


<a id="org0f5d23a"></a>

# Portability

I have no access to Windows. It would we nice to have some feedback
concerning this platform:

-   [X] Mathematica  + Linux
-   [X] Mathematica  + MacOS
-   [ ] Mathematica  + Windows ???


<a id="orga5b76b3"></a>

# How it works?


<a id="org7b74380"></a>

## `meson.build`

    #----------------
    # Regular Meson C++ project
    #----------------
    project('Meson_MMA_Demo', 'cpp')
    
    subdir('src')
    
    #----------------
    # MMA specific
    #----------------
    
    subdir('mma')

The `src` directory contains a [regular C++ meson project](#orgcc63643), which is
compiled in a regular way.

After that we move to the [mma directory](#org52641b3) which is dedicated to the
Mathematica part.

> **Remark**: 
> 
> Even if you do not have Mathematica installed, the C++ library (in the
>  `./src/` directory) is properly compiled and installed.


<a id="orgcc63643"></a>

## `./src/meson.build`

As explained, this is a regular C++ Meson project:

    myLib_inc = include_directories('.')
    
    subdir('myLib')


<a id="org0970777"></a>

### `./src/myLib/meson.build`

For this small demo we create a dynamic library `libmyLib.so` containing
only one file `algorithm1.cpp`. You can obviously add others files by
appending them to the `myLib_headers` and `myLib_sources` Meson variables.

    myLib_headers = ['algorithm1.hpp']
    myLib_sources = ['algorithm1.cpp']
    
    myLib_lib = library('myLib',
    		   include_directories : myLib_inc,
    		   install : true,
    		   sources: [myLib_headers,myLib_sources])
    
    myLib_dep = declare_dependency(include_directories : myLib_inc,
    			      link_with : myLib_lib)
    
    install_headers(myLib_headers,
    		subdir : 'myLib')


<a id="org52641b3"></a>

## `./mma/meson.build`

This part is specific to MMA.

    #----------------
    # Extract MMA information 
    #----------------
    
    # try MMA v10 first
    mma_wolframscript = find_program('MathematicaScript', required: false)
    if mma_wolframscript.found()
      maa_config = run_command(mma_wolframscript,'-script',files('config.wls'), check: true)
    else
      # then MMA v11
      mma_wolframscript = find_program('wolframscript', required: false)
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

In a **first step** we run the [`config.wls`](#orgd9f27f6) script to extract from MMA the
relevant information required by the Meson build process. These
information are printed in a form easily readable by Meson:

    wolframscript -f config.wls

    /usr/local/Wolfram/Mathematica/11.2/SystemFiles/IncludeFiles/C,/usr/local/Wolfram/Mathematica/11.2/SystemFiles/Links/MathLink/DeveloperKit/Linux-x86-64/CompilerAdditions;/home/picaud/.Mathematica/SystemFiles/LibraryResources/Linux-x86-64;/home/picaud/.Mathematica/Applications

These extracted information are stored into the `mma_include_directories`, `mma_library_install_dir` and `mma_package_install_dir` Meson variables.

In a **second step** we create the `libmylibMMA.so` dynamic library and also
define its `rpath variable` to allow it to find the installed
`libmyLib.so` library (see [Compile and install the package](#org92629d1)).

In a **third step** we define where the MMA package `myLib.wl` will be
installed (here in the `mma_package_install_dir` default location).

That's it!


<a id="orgd9f27f6"></a>

## `config.wls`

The `config.wls` script extracts the relevant information required by the
Meson build process. 

    libraryLinkIncludeDirectories={FileNameJoin[{$InstallationDirectory,"SystemFiles","IncludeFiles","C"}],
    			       FileNameJoin[{$InstallationDirectory,"SystemFiles","Links","MathLink","DeveloperKit",$SystemID,"CompilerAdditions"}]};
    libraryInstallDirectory=FileNameJoin[{$UserBaseDirectory,"SystemFiles","LibraryResources",$SystemID}];
    packageInstallDirectory=FileNameJoin[{$UserBaseDirectory,"Applications"}];
    
    (* MMA < v10.1 does not have native StringRiffle *)
    stringRiffle[stringList_List,sep_String]:=TextString[stringList, ListFormat -> {"", sep, ""}];
    format[s_List]:=stringRiffle[s,","]
    
    (* stdout result in a format Meson can read *)
    Print[format[libraryLinkIncludeDirectories]<>";"<>libraryInstallDirectory<>";"<>packageInstallDirectory]


<a id="org185c8c7"></a>

## Our cpp files

This is really for demo purpose as we simply compute a scalar-vector product w=α.v


<a id="org60a137d"></a>

### The `libmyLib.so` cpp files (our c++ library)

The `./src/myLib/algorithm1.hpp` file:

    #pragma once
    
    #include <cstddef>
    
    namespace myLib
    {
      // For demo purpose: dest <- alpha.source
      void algorithm1(const double alpha,const double* source, double* dest, const size_t n);
    }

The `./src/myLib/algorithm1.cpp` file:

    #include "myLib/algorithm1.hpp"
    
    namespace myLib
    {
      void algorithm1(const double alpha, const double* source, double* dest, const size_t n)
      {
        for (size_t i = 0; i < n; i++)
        {
          dest[i] = alpha*source[i];
        }
      }
    
    }  // namespace myLib


<a id="orgc6c94c2"></a>

### The `libmyLibMMA.so` cpp files (our MMA wrapper)

The `./mma/myLib_mma.cpp` file:

    #include "WolframLibrary.h"
    #include "WolframSparseLibrary.h"
    
    extern "C" DLLEXPORT mint WolframLibrary_getVersion() { return WolframLibraryVersion; }
    extern "C" DLLEXPORT int WolframLibrary_initialize(WolframLibraryData libData) { return LIBRARY_NO_ERROR; }
    extern "C" DLLEXPORT void WolframLibrary_uninitialize(WolframLibraryData libData) { return; }

The `./mma/algorithm1_mma.cpp` file:

    #include <cassert>
    #include <iostream>
    
    #include "WolframLibrary.h"
    #include "WolframSparseLibrary.h"
    
    #include "myLib/algorithm1.hpp"
    
    //----------------
    
    // TODO replace asserts by MMA error message
    extern "C" DLLEXPORT int algorithm1(WolframLibraryData libData, mint Argc, MArgument* Args, MArgument Res)
    {
      // alpha
      const double alpha = MArgument_getReal(Args[0]);
      // source vector
      const MTensor src_tensor = MArgument_getMTensor(Args[1]);
      assert(libData->MTensor_getType(src_tensor)==MType_Real);
      const mint src_rank = libData->MTensor_getRank(src_tensor);
      assert(src_rank == 1);
      const mint* const src_dims = libData->MTensor_getDimensions(src_tensor);
      const double* const src_data = libData->MTensor_getRealData(src_tensor);
      // dest vector
      MTensor dest_tensor;
      const mint dest_rank = src_rank;
      const mint dest_dims[] = { src_dims[0] };
      libData->MTensor_new(MType_Real, dest_rank, dest_dims, &dest_tensor);
      double* const dest_data = libData->MTensor_getRealData(dest_tensor);
    
      // call our libmyLib.so function 
      myLib::algorithm1(alpha,src_data,dest_data,src_dims[0]);
      
      MArgument_setMTensor(Res, dest_tensor);
      return LIBRARY_NO_ERROR;
    }


<a id="org4bde0a1"></a>

# Useful references

-   [Doing nothing with LibraryLink](https://community.wolfram.com/groups/-/m/t/189016) certainly the place to begin with if
    you do not know LibraryLink yet.
-   [a short but instructive video about LibraryLink](https://www.youtube.com/watch?v=Acjjj6zGem0&t=1172s) some tips (youtube video)
-   [Wolfram LibraryLink User Guide (official)](https://reference.wolfram.com/language/LibraryLink/tutorial/Overview.html)
-   <https://github.com/arnoudbuzing/wolfram-librarylink-examples>
-   [NumericArray—Compact Representation of "Numeric" Arrays](https://www.youtube.com/watch?v=5Km3kXnCMUw&list=PLxn-kpJHbPx0VeBoNETYfeiHxsX0i-Dbl&index=65) (youtube video)

**Note:** I also have written a bash-script to generate pure C++ project
templates (configured with gtest and doxygen): [meson\_starter\_script](https://github.com/vincent-picaud/meson_starter_script).

