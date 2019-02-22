
# Table of Contents

1.  [Caveat](#orgb618e98)
2.  [What is it?](#org4807fa2)
3.  [How to use it?](#org4eb60dd)
    1.  [Using `./sandbox/demo_sparse.wls` mma file](#org821d20e)
    2.  [Using command line](#orge7a51a1)
4.  [Help needed](#org2cf2ae0)
5.  [Main files](#orgb51a1b4)
6.  [Some details](#orgdd5cdb5)
    1.  [`config.wls`](#orge7f2821)
    2.  [Meson files](#org74f696c)
        1.  [`./meson.build`](#orgd6bd11d)
        2.  [`./src/meson.build`](#org0efc28f)



<a id="orgb618e98"></a>

# Caveat

Do not modify this `README.md` file: it is **automatically** generated
from `README.org`. Modify `README.org` instead (Emacs + OrgMode)


<a id="org4807fa2"></a>

# What is it?

The goal is to use the [Meson build system](https://mesonbuild.com/) to define an **easy to use** and
**portable** solution for [Wolfram LibraryLink developments](https://reference.wolfram.com/language/LibraryLink/tutorial/InteractionWithMathematica.html). This GitHub
repo is my effort and a (possible) proof of concept for this.


<a id="org4eb60dd"></a>

# How to use it?


<a id="org821d20e"></a>

## Using `./sandbox/demo_sparse.wls` mma file

Open `./sandbox/demo_sparse.wls` with Mathematica and follow instructions. It should:

-   clone this git repo (in the system temporary directory)
-   do the build using Meson. 
    
    The `sparseDemoPackage` is generated, opened and a simple function using
    the generated dynamic library is tested.
    
    If the package does not work you can try to build it manually using
    `./sandbox/demo_sparse_manual.wls.` This file uses the `CreateLibrary` and
    `LibraryFunctionLoad` mma functions instead of the meson build process.


<a id="orge7a51a1"></a>

## Using command line

    git clone git@github.com:vincent-picaud/mma_meson_demo.git
    cd mma_meson_demo
    meson build 
    cd build
    ninja install

Then, under Mathematica:

    <<"sparseDemoPackage`"
    ?sparseDemoPackage`*
    s=SparseArray[{{1,0,0},{2 ,0,3}}]
    test[s] // TableForm


<a id="org2cf2ae0"></a>

# Help needed

For the moment I was only able to test it under Linux. I have no
access to Windows nor MacOS platforms. It would we nice to have some
feedback (and probable fixes) concerning these platforms.

-   [X] Mathematica v10.0 + Linux
-   [X] Mathematica v11.2 + Linux
-   [ ] Mathematica  + Windows ?
-   [ ] Mathematica  + MacOS ?


<a id="orgb51a1b4"></a>

# Main files

> -   config.wls   <- mma script to extract configuration information
> -   meson.build  <- meson build system file
> -   README.md    <- **this** file
> -   README.org   <- my org mode file (used to generate README.md)
> -   sandbox/     <- contains mma files  to check if it works
>     -   demo\_sparse\_manual.wls <- manual steps, without using meson
>     -   demo\_sparse.wls        <- automatic build using meson
> -   src/         <- package sources, including C++, C and mma codes
>     -   demo\_sparse.cpp        <- extracted from the official LibraryLink doc
>     -   meson.build            <- meson build system file
>     -   sparseDemoPackage.wl   <- mma package using the dynamic lib generated from demo\_sparse.cpp


<a id="orgdd5cdb5"></a>

# Some details


<a id="orge7f2821"></a>

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


<a id="org74f696c"></a>

## Meson files

I tried to only use the strict minimum to make it works.


<a id="orgd6bd11d"></a>

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


<a id="org0efc28f"></a>

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

