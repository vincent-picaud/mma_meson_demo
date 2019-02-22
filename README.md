
# Table of Contents

1.  [Caveat](#org889aba4)
2.  [What is it?](#orgff69bb5)
3.  [How to use it?](#orge996d0a)
4.  [Help needed](#org8c7c702)
5.  [Main files](#org7f48b60)
6.  [Some details](#orga41c70d)
    1.  [`config.wls`](#org1637a5a)
    2.  [Meson files](#org78ca1bd)
        1.  [`./meson.build`](#org2d51812)
        2.  [`./src/meson.build`](#org7f62a66)



<a id="org889aba4"></a>

# Caveat

Do not modify this `README.md` file: it is **automatically** generated
from `README.org`. Modify `README.org` instead (Emacs + OrgMode)


<a id="orgff69bb5"></a>

# What is it?

The goal is to use the [Meson build system](https://mesonbuild.com/) to define an **easy to use** and
**portable** solution for [Wolfram LibraryLink developments](https://reference.wolfram.com/language/LibraryLink/tutorial/InteractionWithMathematica.html). This GitHub
repo is my effort and a (possible) proof of concept for this.


<a id="orge996d0a"></a>

# How to use it?

Open `./sandbox/demo_sparse.wls` with Mathematica and check if its
works. It should clone this git repo (in the system temporary
directory) and do the build using Meson. 

The `sparseDemoPackage` is generated, opened and a simple function using
the generated dynamic library is tested.

If the package does not work you can try to build it manually using
`./sandbox/demo_sparse_manual.wls.` This file uses the `CreateLibrary` and
`LibraryFunctionLoad` mma functions instead of the meson build process.


<a id="org8c7c702"></a>

# Help needed

For the moment I was only able to test it under Linux. I have no
access to Windows nor MacOS platforms. It would we nice to have some
feedback (and probable fixes) concerning these platforms.

-   [X] Mathematica v10.0 + Linux
-   [X] Mathematica v11.2 + Linux
-   [ ] Mathematica  + Windows ?
-   [ ] Mathematica  + MacOS ?


<a id="org7f48b60"></a>

# Main files

> -   config.wls   <- mma script to extract configuration information
> -   meson.build  <- meson build system file
> -   README.md    <- **this** file
> -   README.org   <- my org mode file (used to generate README.md)
> -   sandbox/     <- contains mma files  to check if it works
>     -   demo<sub>sparse</sub><sub>manual.wls</sub> <- manual steps, without using meson
>     -   demo<sub>sparse.wls</sub>        <- automatic build using meson
> -   src/         <- package sources, including C++, C and mma codes
>     -   demo<sub>sparse.cpp</sub>        <- extracted from the official LibraryLink doc
>     -   meson.build            <- meson build system file
>     -   sparseDemoPackage.wl   <- mma package using the dynamic lib generated from demo<sub>sparse.cpp</sub>


<a id="orga41c70d"></a>

# Some details


<a id="org1637a5a"></a>

## `config.wls`

The `config.wls` file extracts the relevant information required by the
Meson build process.

    libraryLinkIncludeDirectories={FileNameJoin[{$InstallationDirectory,"SystemFiles","IncludeFiles","C"}],
    			       FileNameJoin[{$InstallationDirectory,"SystemFiles","Links","MathLink","DeveloperKit",$SystemID,"CompilerAdditions"}]};
    libraryInstallDirectory=FileNameJoin[{$UserBaseDirectory,"SystemFiles","LibraryResource",$SystemID}];
    packageInstallDirectory=FileNameJoin[{$UserBaseDirectory,"Applications"}];
    
    (* buildDirectory=Environment["MESON_BUILD_ROOT"]; *)
    
    (* MMA < v10.1 does not have native StringRiffle *)
    stringRiffle[stringList_List,sep_String]:=TextString[stringList, ListFormat -> {"", sep, ""}];
    
    format[s_List]:=stringRiffle[s,","]
    
    (* stdout result *)
    Print[format[libraryLinkIncludeDirectories]<>";"<>libraryInstallDirectory<>";"<>packageInstallDirectory]


<a id="org78ca1bd"></a>

## Meson files

I tried to only use the strict minimum to make it works.


<a id="org2d51812"></a>

### `./meson.build`

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


<a id="org7f62a66"></a>

### `./src/meson.build`

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

