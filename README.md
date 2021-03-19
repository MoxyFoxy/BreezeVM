# BreezeVM
BreezeVM is a virtual machine built for simplicity of targeting, specifically for dynamic languages.

## Additional Features
* Assembler for turning BreezeVM Assembly (BVMAsm) into Breeze Bytecode (BBC, or a .bbc file).
* Has a type-agnostic stack.
* Can declare types at runtime.
* Dynamic amount of "registers" through prepared values.

#### Todo Features
* Main VM.
* VM instructions.
* Intrinsic procedures.

#### Planned Features (after graduation)
* Flags and full CLI.
* Shared library imports.
* Standardized interface for shared libraries.
* Compile-time and runtime number type.

## .bbc File Format
The BreezeVM depends on a very specific format that .bbc files have to conform to. The assembler conforms to this, but the format will be described here for any potential third-party applications. Note that this file format may be subject to change, especially after my graduation.


64 bits => Length of the entire header in bytes.

64 bits => Amount of procedure descriptors.
64 bits => Length of the procedure descriptors in bytes.
N bits => An array of procedure descriptors. Code [here](https://github.com/F0x1fy/BreezeVM/blob/master/Source/BreezeVM/Types/interpreter.odin#L14). Name must be followed by a null terminator.

64 bits => Amount of foreign imports.
64 bits => Length of the foreign imports in bytes.
N bits => An array of foreign import names. The names are null-terminated strings.

64 bits => Amount of data descriptors.
64 bits => Length of the data descriptors in bytes.
N bits => An array of data descriptors. Code [here](https://github.com/F0x1fy/BreezeVM/blob/master/Source/BreezeVM/Types/stack.odin#L25).

64 bits => Length of read-only data in bytes. Though this CAN be computed by subtracted an offset from the header length and a u64, this is kept here for consistency and ease of use.
N bits => An array of bytes for the read-only data.

64 bits => Length of the binary.
N bits => The executable binary.

## Instructions
This will be done after the instructions have been finalized, but the instructions with full documentation can be found (here!)(https://github.com/F0x1fy/BreezeVM/blob/master/Source/BreezeVM/Bytecode/bytecode.odin).