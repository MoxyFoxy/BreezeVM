package HeaderOutput

import Runtime "core:runtime"
import FMT "core:fmt"

import "breeze:Types"

Header_Context :: struct {
    off: u64,
    last_off: u64,

    ro_data: [dynamic] Types.Header_Type,
    ro_buf : [dynamic] byte,
    imports: [dynamic] string,
    imports_shared: [dynamic] string,
}

// Initializes a default header context based on the given buffer input size.
initialize_header_context :: proc () -> Header_Context {
    ro_data := make ([dynamic] Types.Header_Type);
    ro_buf  := make ([dynamic] byte);

    imports        := make ([dynamic] string);
    imports_shared := make ([dynamic] string);

    return Header_Context {0, 0, ro_data, ro_buf, imports, imports_shared};
}

write_import_to_header_context :: #force_inline proc (ctx: ^Header_Context, import_str: string) {
    append (&ctx.imports, import_str);
}

write_import_shared_to_header_context :: #force_inline proc (ctx: ^Header_Context, import_str: string) {
    append (&ctx.imports_shared, import_str);
}

// Writes a header type to the header context.
write_type_to_header_context :: #force_inline proc (ctx: ^Header_Context, type: Types.Header_Type) {
    ctx := ctx;

    append (&ctx.ro_data, type);
    ctx.off += 1;
}

// Writes any value to the header context's buffer.
write_to_header_context :: proc (ctx: ^Header_Context, value: $T) {
    ctx   := ctx;
    value := value;

    // Grow the buffer to the desired size.
    #unroll for i in 0..<size_of (T) {
        append (&ctx.ro_buf, (transmute (^u8) (transmute (uintptr) &value + transmute (uintptr) i))^);
    }
}

write_string_to_header_context :: proc (ctx: ^Header_Context, str_len: u64, value: rawptr) {
    ctx     := ctx;
    str_len := str_len;
    value   := value;

    // Grow the buffer to the desired size to write the string.
    for i in 0..<str_len {
        append (&ctx.ro_buf, (transmute (^u8) (transmute (uintptr) value + transmute (uintptr) i))^);
    }
}

// Pulls a byte-typed array from the header context.
to_byte_array :: proc (ctx: ^Header_Context) -> [] byte {
    return ctx.ro_buf[:];
}