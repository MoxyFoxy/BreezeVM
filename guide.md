# BreezeVM User and System Administrator Guide
This user guide covers how to download, build, and use each part of BreezeVM. If any issues are encountered building the program, feel free to email [alecsanchez@avian-lang.org](mailto:alecsanchez@avian-lang.org).

## How to Download BreezeVM
There are three ways to download BreezeVM: through the GitHub release binaries, through `git` (source), and through a `.zip` file (source).

### Download Binaries
By downloading the binaries, [How To Build BreezeVM](#how-to-build-breezevm) can be skipped. To skip building Breeze, please go to [How to Use BVMAsm](#how-to-use-bvmasm).

To download the binaries, simply go to the [Senior Capstone release](https://github.com/F0x1fy/BreezeVM/releases/tag/capstone) and download the binaries for your OS (`Linux.tar.xz` for a Linux/GNU OS and `Windows.zip` for PC).

### Through Git
To download BreezeVM through `git`, make sure to have [git](https://git-scm.com/) installed, then head to a directory where to clone BreezeVM (can be anywhere), then simply type "`git clone https://github.com/F0x1fy/BreezeVM.git`". This will then download the repository in a "`BreezeVM`" subdirectory.

### Through a ZIP File
Please click [here](https://github.com/F0x1fy/BreezeVM/releases/download/capstone/BreezeVM-Source.zip) to download the ZIP file for the Senior Capstone release.

## How to Build BreezeVM
This section assumes the user has at least basic understanding in using and navigating both Linux and the shell. If you do not wish to build BreezeVM, but just use it, please go to [Download Binaries](#download-binaries).

Building BreezeVM requires a program that can operate on `Makefile`s, as well as the [Odin](http://odin-lang.org/) compiler. The recommended program is [make](https://www.gnu.org/software/make/) on Linux. Note that these make commands require Linux, though the commands within them (with the exclusion of "`find`") can be ran manually on Windows, given that the [Odin](http://odin-lang.org/) compiler is installed. [LLVM](https://llvm.org/) and [mingw-w64](http://mingw-w64.org/doku.php/download/linux) are also required for the linking stages when using make.

There is a `Makefile` in the root directory of the project. All `make` commands must be ran in the root of the repository.

* To update the repo, simply type "`make update-breeze`", which is just "`git pull`" under the hood. This requires [git](https://git-scm.com/).

```
> make update-breeze
git pull
Already up to date.
```

* To update the `lib` (currently unused, but may be used in the future), run "`make update-lib`".

```
> make update-lib
find bin/* -not -name '.gitkeep' -delete
Binary directory has been cleaned.
```

* To build the assembler, run "`make assembler`". The assembler will then be created in the `bin` directory.

```
> make assembler
Compiling BVM Assembler for Linux...
Linking to create binary...
Cleaning directory...
BVM Assembler for Linux is complete.
```

Then, a `bvmasm` binary file will be created in the `bin/Linux` directory.

* To build the VM, run "`make vm`". The VM will then be created in the `bin/Linux` directory.

```
> make vm
Compiling BVM for Linux...
Linking to create binary...
Cleaning directory...
BVM for Linux is complete.
```

Then, a `bvm` binary file will be created in the `bin` directory.

* To cross-compile the Assembler for Windows, run `make vm-windows`. The Assembler will then be created in the `bin/Windows` directory.

```
> Compiling BVM Assembler for Windows...
Linking for cross compilation for this platform is not yet supported (windows amd64)
Linking to create binary...
Cleaning directory...
BVM Assembler for Windows is complete.
```
(The `Linking for cross compilation...` warning can be ignored. There is no way to subdue the warning)

* To cross-compile the VM for Windows, run `make vm-windows`. The VM will then be created in the `bin/Windows` directory.

```
> make vm-windows
Compiling BVM for Windows...
Linking for cross compilation for this platform is not yet supported (windows amd64)
Linking to create binary...
Cleaning directory...
BVM for Windows is complete.
```
(The `Linking for cross compilation...` warning can be ignored. There is no way to subdue the warning)

* To clean up the binary directory, run "`make clean`".
```
> make clean
find bin/* -not -name '.gitkeep' -delete
Binary directory has been cleaned.
```

Then, the `bin` directory will be emptied except for the `.gitignore` file.

* To build the Assembler and VM for Linux, run `make all-linux`. The Assembler and VM will then be created in the `bin/Linux` directory.

```
Compiling BVM for Linux...
Linking to create binary...
Cleaning directory...
BVM for Linux is complete.

Compiling BVM Assembler for Linux...
Linking to create binary...
Cleaning directory...
BVM Assembler for Linux is complete.
```

* To cross-compile the Assembler and VM for Windows, run `make all-windows`. The Assembler and VM will then be created in the `bin/Windows` directory.

```
Compiling BVM for Windows...
Linking for cross compilation for this platform is not yet supported (windows amd64)
Linking to create binary...
Cleaning directory...
BVM for Windows is complete.

Compiling BVM Assembler for Windows...
Linking for cross compilation for this platform is not yet supported (windows amd64)
Linking to create binary...
Cleaning directory...
BVM Assembler for Windows is complete.
```
(The `Linking for cross compilation...` warnings can be ignored. There is no way to subdue the warning)

* To build the Assembler and VM for both Linux and Windows, run `make all`. The Assembler and VM will then be created in both the `bin/Linux` and `bin/Windows` directory.

```
Compiling BVM for Linux...
Linking to create binary...
Cleaning directory...
BVM for Linux is complete.

Compiling BVM Assembler for Linux...
Linking to create binary...
Cleaning directory...
BVM Assembler for Linux is complete.

Compiling BVM for Windows...
Linking for cross compilation for this platform is not yet supported (windows amd64)
Linking to create binary...
Cleaning directory...
BVM for Windows is complete.

Compiling BVM Assembler for Windows...
Linking for cross compilation for this platform is not yet supported (windows amd64)
Linking to create binary...
Cleaning directory...
BVM Assembler for Windows is complete.
```
(The `Linking for cross compilation...` warnings can be ignored. There is no way to subdue the warning)

## How to Use BVMAsm
In order to assemble a [BVMAsm](#what-is-breezevm) file, first create a file titled "`[name].bvmasm`" (where "`[name]`" can be any name wanted) with valid BVMAsm in it, then call the assembler (`bvmasm`) on the file(s). A `program.bbc` file will be created if there are no errors. Any errors will be printed out before the program halts.

Example of use:
```
> bvmasm hello-world.bvmasm
Completed binary in 0.232ms.
```
(Time may differ based on outside factors)

Then, running "`ls`" reveals that a `program.bbc` file has been created, which can later be used by `bvm` for interpretation:
```
> ls
hello-world.bvmasm  program.bbc
```

## How to Use BVM
In order to interpret a [.bbc](#what-is-breezevm) file, call the VM (`bvm`) on the file. From there, the VM will attempt to load then de-serialize the file passed. If it does not find the file, or the serialization is invalid, the VM will halt and error out. If there are any errors during interpretation, the VM will error out and halt.

Example of use:
```
> bvm program.bbc
Hello, World!
```

## BVM For Administrators
BVM currently requires no configuration, and will be standard across all builds. There is no hosting or anything similar required to use BreezeVM. `bvmasm` and `bvm` must simply be installed on any computer that needs to use it using the instructions given in [How to Build BreezeVM](#how-to-build-breezevm). BVM, unless intrinsic procedures are added and used that can access outside resources such as the file system and the internet, is entirely isolated and does not pose any inherit security risks that have to be accounted for.
