# Overview
[u-blox GPS receivers](https://www.u-blox.com/en/position-time)
use a UBX binary protocol to transmit GPS data to a host computer using
asynchronous serial ports. This project provides a definition all 
the messages as well as wrapping transport framing used by 
**u-blox 5/6/7/8/9** devices.

The protocol is defined in multiple [schema](dsl)
files using [CommsDSL](https://github.com/commschamp/CommsDSL-Specification).
The **commsds2comms** code generator from [commsdsl](https://github.com/commschamp/commsdsl)
project is used to generate C++11 code of the protocol implementation.

The **generated** CMake project of this protocol definition is hosted and can be
viewed at [cc.ublox.generated](https://github.com/commschamp/cc.ublox.generated)

# Examples
The [examples](examples) directory contains following example applications:
- simple_pos - simple application that communicates to u-blox receiver over
USB serial link and polls for **NAV-POSLLH** messages. When latter is received,
the position is printed to standard output.

# License
Please read [License](https://github.com/commschamp/commsdsl#license)
section from [commsdsl](https://github.com/commschamp/commsdsl) project.

# How to Build
This project uses CMake as its build system. Please open main
[CMakeLists.txt](CMakeLists.txt) file and review available options as well as
mentioned available parameters, which can be used in addition to standard 
ones provided by CMake itself, to modify the default build. 

This project also has external dependencies, it requires an access to
the [COMMS Library](https://github.com/commschamp/commsdsl) and
code generators from [commsdsl](https://github.com/commschamp/commsdsl) projects.
These dependencies are expected to be built independenty and access to them provided
via standard **CMAKE_PREFIX_PATH** and/or **CMAKE_PROGRAM_PATH** (for the binaries of
the code generators). There are also scripts (
[script/prepare_externals.sh](script/prepare_externals.sh) for Linux and
[script/prepare_externals.bat](script/prepare_externals.bat) for Windows)
which can help in preparation of these dependencies. They are also used
in configuration of the [github actions](.github/workflows/actions_build.yml) and
[appveyor](.appveyor.yml).

The [example](#examples) applications use [Boost](https://www.boost.org)
to parse their command line parameters as well as manage their asynchronous I/O. 
In case Boost libraries are not installed in expected default location
(mostly happens on Windows systems), use variables described in 
[CMake documentation](https://cmake.org/cmake/help/v3.8/module/FindBoost.html) 
to help CMake find required libraries and headers. 
It is recommended to use `-DBoost_USE_STATIC_LIBS=ON` parameter to force
linkage with static Boost libraries.

### Linux Build
```
$> cd /source/of/this/project
$> mkdir build && cd build
$> BUILD_DIR=$PWD CC=gcc CXX=g++ COMMON_INSTALL_DIR=$PWD/install COMMON_BUILD_TYPE=Release ../script/prepare_externals.sh
$> cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PWD/install -DCMAKE_PREFIX_PATH=$PWD/install
$> make install
```

### Windows Build
```
$> cd C:\source\of\this\project
$> mkdir build && cd build
$> set BUILD_DIR=%cd%
$> set GENERATOR="NMake Makefiles"
$> set QTDIR=C:\Qt\5.15.2
$> set COMMON_INSTALL_DIR=%cd%/install
$> ..\script\prepare_externals.bat
$> cmake .. -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX=%cd%/install -DCMAKE_PREFIX_PATH=%cd%\install ^
    -DBOOST_ROOT="C:\Libraries\boost_1_65_1" -DBoost_USE_STATIC_LIBS=ON
$> nmake install
```

# Supported Compilers
Please read [Supported Compilers](https://github.com/commschamp/commsdsl#supported-compilers)
info from [commsdsl](https://github.com/commschamp/commsdsl) project.

# How to Build and Use Generated Code
Please read the
[Generated CMake Project Walkthrough](https://github.com/commschamp/commsdsl/blob/master/doc/GeneratedProjectWalkthrough.md)
documentation page for details on the generated project internals.

The [release](https://github.com/commschamp/cc.ublox.commsdsl/releases)
artifacts contain doxygen generated documentation of the protocol definition.

# Contact Information
For bug reports, feature requests, or any other question you may open an issue
here in **github** or e-mail me directly to: **arobenko@gmail.com**. I usually
respond within 24 hours.

