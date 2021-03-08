package Types

Stack_Type :: struct {
    len: int, // Length in bytes.

    // The discriminated union of possible variant types.
    variant: union {
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
}

Pointer :: ^Stack_Type;

Type :: distinct u8;

String  :: distinct Byte_Object;
Array   :: distinct Byte_Object;

Byte_Object :: struct {
    data: rawptr,
}

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