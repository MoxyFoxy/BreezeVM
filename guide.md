# BreezeVM User and System Administrator Guide
This user guide covers how to download, build, and use each part of BreezeVM. If any issues are encountered building the program, feel free to email [alecsanchez@avian-lang.org](mailto:alecsanchez@avian-lang.org).

## How to Download BreezeVM
There are two ways to download BreezeVM: through `git` and through a `.zip` file.

### Through Git
To download BreezeVM through `git`, make sure to have [git](https://git-scm.com/) installed, then head to a directory where to clone BreezeVM (can be anywhere), then simply type "`git clone https://github.com/F0x1fy/BreezeVM.git`". This will then download the repository in a "`BreezeVM`" subdirectory.

### Through a ZIP File
Please click [here](https://github.com/F0x1fy/BreezeVM/archive/refs/heads/master.zip) to download the `ZIP` file.

## How to Build BreezeVM
Building BreezeVM requires a program that can operate on `Makefile`s, as well as the [Odin](http://odin-lang.org/) compiler. The recommended program is [make](https://www.gnu.org/software/make/) on Linux. Note that these make commands require Linux, though the commands within them (with the exclusion of "`find`") can be ran manually on Windows, given that the [Odin](http://odin-lang.org/) compiler is installed.

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
odin build Source/Assembler -out=bin/bvmasm -collection:breeze=Source/BreezeVM -collection:assembler=Source/Assembler
```

Then, a `bvmasm` binary file will be created in the `bin` directory.

* To build the VM, run "`make vm`". The VM will then be created in the `bin` directory.<br />Output should look like:

```
> make vm
odin build Source/BreezeVM -out=bin/bvm -collection:breeze=Source/BreezeVM -collection:assembler=Source/Assembler
```

Then, a `bvm` binary file will be created in the `bin` directory.

* To clean up the binary directory, run "`make clean`".<br />Output should look like:
```
> make clean
find bin/* -not -name '.gitkeep' -delete
Binary directory has been cleaned.
```

Then, the `bin` directory will be emptied except for the `.gitignore` file.

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
