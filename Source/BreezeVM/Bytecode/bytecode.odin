package Bytecode

// The bytecode enumeration for all instructions.
// 
// All instructions output to the prepared values if they have output.
// All instructions that have output are appended with `_O`.
// Prepared statements will append to the prepared values until called.
// 
// All stack offsets are only for the block they are in. Scopes can still
// reference stack space in parent scopes, but blocks cannot reference stack
// space within another block.
Instruction :: enum u16 {

    // Invalid instructions

    INVALID, // Is not a valid instruction. Is only passed when there is an error lexing.

    DATA, // Is not actually an instruction. Signifies that the data segment has begun.
    CODE, // Is not actually an instruction. Signifies that the code segment has begun.

    _RESERVED_INVALID_INSTRUCTIONS = 15,

    // No-bit

    EXIT,       // EXIT. Exits a procedure.
    RETURN,     // RETURN. Exits a procedure and passes its prepared values upwards.

    PUSH_SCOPE, // PUSH_SCOPE. Creates a new scope.
    POP_SCOPE,  // POP_SCOPE. Deletes the current scope in context then proceeds through the parent.

    PUSH_BLOCK, // PUSH_BLOCK. Creates a new block.
    POP_BLOCK,  // POP_BLOCK. Deletes the current block in context and proceeds through the parent.

    HALT,       // HALT. Halts the entire program.

    PUSH_PREPARE_BLOCK, // PUSH_PREPARE_BLOCK. Creates a new prepare block.
    POP_PREPARE_BLOCK,  // POP_PREPARE_BLOCK. Deletes a prepare block, then proceeds to the parent.

    _RESERVED_NO_BIT_INSTRUCTIONS = 40,

    // No-bit multi-value

    PULL,        // PULL. Pulls prepared values from the block onto the stack. This will always be appended to the stack.
    PULL_DELETE, // PULL_DELETE. Pulls prepared values from the block onto the stack, then deletes the prepared block. This will always be appended to the stack.

    ADD_MULTI_O, // ADD_M. Adds multiple prepared values.
    SUB_MULTI_O, // SUB_M. Subtracts multiple prepared values.
    MUL_MULTI_O, // MUL_M. Multiplies multiple prepared values.
    DIV_MULTI_O, // DIV_M. Divides multiple prepared values.
    MOD_MULTI_O, // MOD_M. Performs a standard modulus on multiple prepared values.
    EXP_MULTI_O, // EXP_M. Performs an exponential operation on multiple prepared values, where the first is the base.

    _RESERVED_NO_BIT_MULTI_VALUE_INSTRUCTIONS = 80,

    // No-bit prepared value

    IMPORT,        // IMPORT. Gets the location of a Breeze bytecode package from a string value on the stack to import at runtime.
    IMPORT_SHARED, // IMPORT_SHARED. Gets the location of a shared library from a string value on the stack to import at runtime.

    _RESERVED_NO_BIT_PREPARED_VALUE_INSTRUCTIONS = 160,

    // 64-bit

    PREPARE_O, // PREPARE <u64>[STACK_OFFSET]. Prepares a specific value on the stack for use in multi-value instructions.
    PREPARE_CONST_O, // PREPARE_CONST <u64>[DATA_OFFSET]. Prepares a specific value from read-only data based on the offset.

    JMP, // JMP <i64>[BYTE_OFFSET]. Jumps to a specific offset in the code. Note this is signed.

    GET_PROC_POINTER_O, // GET_PROC_POINTER <u64>[OFFSET]. Gets the name of the procedure from a string value on the stack.

    REF_O, // REF <u64>[STACK_OFFSET]. Prepares a Pointer-type value to specified stack location.

    _RESERVED_64_BIT_INSTRUCTIONS = 200,

    // 64-bit prepared value

    JMPIF, // JMPIF <i64>[BYTE_OFFSET]. Jumps to a specific offset in the code IF all prepared conditions are true. If it not a boolean, it'll check to make sure it is not null. Note this IS signed.

    DECLARE_PREPARED, // DECLARE_PREPARED <u64>[STACK_OFFSET]. Declares a specific type on the stack, zeroing it out, using the first type found in the prepared values.

    DEREF_O, // DEREF <u64>[STACK_OFFSET]. Dereferences the first pointer-type prepared value onto specified stack location.

    _RESERVED_64_BIT_PREPARED_VALUE_INSTRUCTIONS = 240,

    // 64-bit multi-value

    CALL_O,     // CALL <u64>[PROC_CODE]. Calls an intrinstic procedure from its procedure offset in the header. Will pass all prepared values.
    CALL_PROC,  // CALL_PROC <u64>[PROC_OFFSET]. Calls a specific procedure from its procedure offset in the header. Will pass all prepared values.
    CALL_DYN_O, // CALL_DYN <u64>[STACK_OFFSET]. Calls a specific procedure from a pointer or string type. Will pass all prepared values.

    _RESERVED_64_BIT_MULTI_VALUE_INSTRUCTIONS = 280,

    // 72-bit

    DECLARE, // DECLARE <u64>[STACK_OFFSET] <u8>[TYPE]. Declares a type at a specific stack offset. This will generate a zeroed variant of the type.

    _RESERVED_72_BIT_INSTRUCTIONS = 300,

    // 128-bit

    CONST_TO, // CONST_TO <u64>[DATA_OFFSET] <u64>[STACK_OFFSET]. Pulls a data value based on its offset to the specified location on the stack.
    PULL_TO,  // PULL_TO <u64>[PREPARE_OFFSET] <u64>[STACK_OFFSET]. Pulls prepared value based on its offset onto the specified location on the stack.

    ADD_O, // ADD <u64>[STACK_OFFSET] <u64>[STACK_OFFSET]. Adds two values on the stack.
    SUB_O, // SUB <u64>[STACK_OFFSET] <u64>[STACK_OFFSET]. Subtracts two values on the stack.
    MUL_O, // MUL <u64>[STACK_OFFSET] <u64>[STACK_OFFSET]. Multiplies two values on the stack.
    DIV_O, // DIV <u64>[STACK_OFFSET] <u64>[STACK_OFFSET]. Divides two values on the stack.
    MOD_O, // MOD <u64>[STACK_OFFSET] <u64>[STACK_OFFSET]. Performs a standard modulus on two values on the stack.
    EXP_O, // EXP <u64>[STACK_OFFSET] <u64>[STACK_OFFSET]. Performs an exponential operation on two values on the stack.

    EQUAL_O,      // EQUAL <u64>[STACK_OFFSET] <u64>[STACK_OFFSET]. Checks to see if the first value is equal to the second value.
    GREATER_O,    // GREATER <u64>[STACK_OFFSET] <u64>[STACK_OFFSET]. Checks to see if the first value is greater than the second value.
    LESSER_O,     // LESSER <u64>[STACK_OFFSET] <u64>[STACK_OFFSET]. Checks to see if the first value is less than the second value.
    GREATER_EQ_O, // GREATER_EQ <u64>[STACK_OFFSET] <u64>[STACK_OFFSET]. Checks to see if the first value is greater than or equal to the second value.
    LESSER_EQ_O,  // LESSER_EQ <u64>[STACK_OFFSET] <u64>[STACK_OFFSET]. Checks to see if the first value is less than or equal to the second value.

    DECLARE_FROM, // DECLARE_FROM <u64>[STACK_OFFSET] <u64>[STACK_OFFSET]. Declares a type at a specific stack offset given the type declared at a specific offset. This will generate a zeroed variant of the type.

    DEREF_TO, // DEREF_TO <u64>[STACK_OFFSET] <u64>[STACK_OFFSET]. Dereferences pointer-type first stack location to second stack location.

    _RESERVED_128_BIT_INSTRUCTIONS = 350,

    // 136-bit

    OFFSET_O, // OFFSET <u64>[STACK_OFFSET] <u64>[STACK_OFFSET] <u8>[TYPE]. Gets the offset of a pointer type, byte object, string type, or array type, where the first value is the object and the second is the offset.

    _RESERVED_136_BIT_INSTRUCTIONS = 370,
}

// These are instructions that can be used in the
// data section of the BVMAsm file.
DataInstruction :: enum u8 {
    INVALID, // Padding to make sure that `get_type` can return an invalid value.

    IMPORT,        // IMPORT <str>[LOCATION]. Adds a BVMAsm file into the import queue.
    IMPORT_SHARED, // IMPORT_SHARED <str>[LOCATION]. Adds shared library into the import queue.
    STORE,         // STORE <u8>[TYPE] <val>[VALUE]. Stores a value in the header of type String, Integer, Unsigned Integer, Float, or Boolean.
}

// These are the possible types within
// the BVM.
Type :: enum u8 {
    INVALID,

    Pointer,
    String,
    Array,
    Byte_Object,

    // Default: I64
    Integer,
        Int, I8, I16,   I32,   I64,   I128,
                 I16le, I32le, I64le, I128le,
                 I16be, I32be, I64be, I128be,

    // Default: U64
    Unsigned_Integer,
        Uint, U8, U16,   U32,   U64,   U128,
                  U16le, U32le, U64le, U128le,
                  U16be, U32be, U64be, U128be,

    // Default: F64
    Float,
        F32, F64,

    // Default: Bool
    Boolean,
        Bool, B8, B16, B32, B64,
}