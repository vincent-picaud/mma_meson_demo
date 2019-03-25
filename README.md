
# Table of Contents

1.  [What is it?](#org8b99f6a)
2.  [How to use it?](#orgcab87dd)
    1.  [Compile and install the package](#orgff6910d)
    2.  [Mathematica side](#orgd051d0c)
3.  [Portability](#org51eeb95)
4.  [How it works?](#orgb518086)
    1.  [meson.build](#orgc1f69d2)
    2.  [./src/meson.build](#orgb8970f0)
        1.  [./src/myLib/meson.build](#org7ecc371)
    3.  [./mma/meson.build](#org4c49445)
    4.  [`config.wls`](#org8b76e7d)
    5.  [Meson files](#orgcebab5e)
        1.  [`./meson.build`](#orgbf1d92c)
        2.  [`./src/meson.build`](#org11fa244)
5.  [Useful references](#org3adccd2)



<a id="org8b99f6a"></a>

# What is it?

The goal is to use the [Meson build system](https://mesonbuild.com/) to define an **easy to use** and
**portable** solution for Mathematica [Wolfram LibraryLink developments](https://reference.wolfram.com/language/LibraryLink/tutorial/InteractionWithMathematica.html). This GitHub
repo is a small illustrative example.

The important files are:

-   meson.build
-   mma/
    -   algorithm1\_mma.cpp
    -   config.wls
    -   meson.build
    -   myLib.wl
-   src/
    -   meson.build
    -   myLib/
        -   algorithm1.cpp
        -   algorithm1.hpp
        -   meson.build


<a id="orgcab87dd"></a>

# How to use it?


<a id="orgff6910d"></a>

## Compile and install the package

    git clone git@github.com:vincent-picaud/mma_meson_demo.git
    cd mma_meson_demo
    meson build --prefix=./install_dir
    cd build
    ninja install

> **Remark**: [required &#x2013;prefix=./install\_dir]
> 
> This demo will generate two dynamic libraries:
> 
> -   `libmyLib.so` a regular C++ library (totally independent of MMA)
> -   `libmylibMMA.so` a dynamic library that uses MMA's LibraryLink to wrap functions contained in `libmyLib.so`.
> 
> By default `libmylibMMA.so` is installed in the user directory
> (`$HOME/.Mathematica/SystemFiles/LibraryResources/Linux-x86-64` in my
> case). You can change that if you want (for the moment by modifying
> the meson.build file). However the important point to understand is
> that `libmylibMMA.so` needs to know where the `libmyLib.so` library is. We
> provide this information by embedding this location into
> `libmylibMMA.so` using its [`rpath` section](https://amir.rachum.com/blog/2016/09/17/shared-libraries/). This section is filled
> (without pain using [Meson install\_rpath option](https://mesonbuild.com/Reference-manual.html#executable)!) at **installation**
> time. That is the reason why we define the `--prefix` variable to
> **locally** install `libmyLib.so`. If this `--prefix` variable is not defined
> everything works equally well except that you will need extra
> permissions to do a **system** install (triggered by `ninja install`).


<a id="orgd051d0c"></a>

## Mathematica side

Then, under Mathematica (MMA):

    << myLib`
    
    ?"myLib`*"
    data = {2, 1, 3, 5, 6, 6, 4, 3, 2, 4, 7, 3, 2, 4, 2, 2, 1};
    algorithm1[data, 10]

> **Remark**: [ ``myLib`Private`unload[]`` ]
> 
> During development, if you recompile the c++ code, you must unload the
> library to make MMA taking account the modification. To do that you
> only have to call: ``myLib`Private`unload[]`` under MMA session.


<a id="org51eeb95"></a>

# Portability

I have no access to Windows. It would we nice to have some feedback
concerning this platform. So far, tested with MMA V11.2 under these
platforms:

-   [X] Mathematica  + Linux
-   [X] Mathematica  + MacOS
-   [ ] Mathematica  + Windows ?


<a id="orgb518086"></a>

# How it works?


<a id="orgc1f69d2"></a>

## meson.build

    #----------------
    # Regular Meson C++ project
    #----------------
    project('Meson_MMA_Demo', 'cpp')
    
    subdir('src')
    
    #----------------
    # MMA specific
    #----------------
    mma_wolframscript = find_program('wolframscript')
    
    if mma_wolframscript.found()
      subdir('mma')
    else
      warning('Mathematica not found!')
    endif

The `src` directory contains a [regular C++ meson project](#orgb8970f0). Then we test
if `wolframscript` is present, if so we move to the [`mma` directory](#org4c49445). 

> **Remark**: Even if you do not have MMA installed the C++ library part is
> properly compiled and installed.


<a id="orgb8970f0"></a>

## ./src/meson.build

This is a regular C++ Meson project:

    inc = include_directories('.')
    
    subdir('myLib')


<a id="org7ecc371"></a>

### ./src/myLib/meson.build

For this small demo we create a dynamic library `libmyLib.so`
containing only one file `algorithm1.cpp`. You can obviously add others
files by appending them to `myLib_headers` and `myLib_sources`.

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


<a id="org4c49445"></a>

## ./mma/meson.build

    #----------------
    # Extract MMA information 
    #----------------
    maa_config = run_command(mma_wolframscript,'-f',files('config.wls'), check: true)
    
    maa_config = maa_config.stdout().split(';')
    
    mma_include_directories = include_directories(maa_config.get(0).split(','))
    mma_library_install_dir = maa_config.get(1).strip() # caveat: strip is mandatory to get 
    mma_package_install_dir = maa_config.get(2).strip() # a correct filename
    
    message('MMA library installation directory: '+mma_library_install_dir)
    message('MMA package installation directory: '+mma_package_install_dir)
    
    #----------------
    # myLibMMA library 
    #----------------
    
    myLibMMA_sources = ['algorithm1_mma.cpp']
    
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


<a id="org8b76e7d"></a>

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

With my configuration

    wolframscript -f config.wls

returns 

    /usr/local/Wolfram/Mathematica/11.2/SystemFiles/IncludeFiles/C,/usr/local/Wolfram/Mathematica/11.2/SystemFiles/Links/MathLink/DeveloperKit/Linux-x86-64/CompilerAdditions;/home/picaud/.Mathematica/SystemFiles/LibraryResources/Linux-x86-64;/home/picaud/.Mathematica/Applications

These information are printed in a form easily readable by Meson (see )


<a id="orgcebab5e"></a>

## Meson files

I tried to only use the strict minimum to make it works.


<a id="orgbf1d92c"></a>

### `./meson.build`

    #----------------
    # Regular Meson C++ project
    #----------------
    project('Meson_MMA_Demo', 'cpp')
    
    subdir('src')
    
    #----------------
    # MMA specific
    #----------------
    mma_wolframscript = find_program('wolframscript')
    
    if mma_wolframscript.found()
      subdir('mma')
    else
      warning('Mathematica not found!')
    endif


<a id="org11fa244"></a>

### `./src/meson.build`

    inc = include_directories('.')
    
    subdir('myLib')


<a id="org3adccd2"></a>

# Useful references

-   [Doing nothing with LibraryLink](https://community.wolfram.com/groups/-/m/t/189016) a great tutorial, certainly the place where to begin with
-   [a short but instructive video about LibraryLink](https://www.youtube.com/watch?v=Acjjj6zGem0&t=1172s)
-   [Wolfram LibraryLink User Guide (official)](https://reference.wolfram.com/language/LibraryLink/tutorial/Overview.html)

