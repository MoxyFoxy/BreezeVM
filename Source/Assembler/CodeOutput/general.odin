package CodeOutput

import Runtime "core:runtime"

import "breeze:Types"

Code_Context :: struct {
    off: u64,
    ro_last_off: u64,
    buf: [dynamic] byte,

    procs: [dynamic] Types.Procedure,
}

// Initializes a default code context based on the given buffer input size.
initialize_code_context :: proc () -> Code_Context {
    buf   := make ([dynamic] byte           );
    procs := make ([dynamic] Types.Procedure);

    return Code_Context { 0, 0, buf, procs, };
}

// Writes any value to the code context's buffer.
write_to_code_context :: proc (ctx: ^Code_Context, value: $T) {
    ctx   := ctx;
    value := value;

    // Grow the buffer to the desired size.
    #unroll for i in 0..<size_of (T) {
        append (&ctx.buf, 0x00);
    }

    // Do a mem_copy of the generic type onto the context bytecode buffer.
    Runtime.mem_copy (&ctx.buf[ctx.off], &value, size_of (T));

    // Be sure to update the offset so that
    // data isn't overwritten.
    ctx.off += size_of (T);
}

// Pulls a byte-typed array from the code context.
to_byte_array :: proc (ctx: ^Code_Context) -> [] byte {
    return ctx.buf[:ctx.off];
}