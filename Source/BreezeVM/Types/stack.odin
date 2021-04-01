package Types

import "breeze:Bytecode"

Stack_Type :: struct {
    len: u64, // Length in bytes, or in the case of arrays, how many values there are.
    type: Bytecode.Type, // The type, mapped to an external
                         // enum that flattens the child
                         // and parent types.

    // The discriminated union of possible variant types.
    variant: Stack_Variant,
}

Stack_Variant :: union {
    Pointer,
    Type,
    String,
    Array,
    Byte_Object,
    Integer,
    Unsigned_Integer,
    Float,
    Boolean,
}

Header_Type :: struct {
    len: u64,
    val_off: u64,
    type: Bytecode.Type,
}

Pointer :: ^Stack_Type;

Type :: distinct u8;

String :: distinct Byte_Object;
Array  :: distinct Byte_Object;

Byte_Object :: distinct rawptr;

Integer :: union {
    int, i8, i16,   i32,   i64,   i128,
             i16le, i32le, i64le, i128le,
             i16be, i32be, i64be, i128be,
}

Unsigned_Integer :: union {
    uint, u8, u16,   u32,   u64,   u128,
              u16le, u32le, u64le, u128le,
              u16be, u32be, u64be, u128be,
}

Float :: union {
    f32, f64,
}

Boolean :: union {
    bool, b8, b16, b32, b64,
}

Operation_Type :: enum {
    Unknown, Numeric, String, Array, Byte_Object,
}