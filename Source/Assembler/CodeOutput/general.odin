package CodeOutput

main :: proc () {

}

import IO "core:io"
import "core:fmt"
import Runtime "core:runtime"

import Types "breeze:Types"

Code_Context :: struct {
    off: u64,
    buf: [] byte,

    procs: [dynamic] Types.Procedure,
}

// Initializes a default code context based on the given buffer input size.
initialize_code_context :: proc (input_size: int) -> Code_Context {
    buf   := make ([] byte, input_size);
    procs := make ([dynamic] Types.Procedure);

    return Code_Context { 0, buf, procs, };
}

// Writes any value to the code context's buffer.
write_to_code_context :: proc (ctx: ^Code_Context, value: $T) {
    ctx   := ctx;
    value := value;

    // Do a mem_copy of the generic type onto the context bytecode buffer.
    Runtime.mem_copy (&ctx.buf[ctx.off], &value, size_of (T));

    // Be sure to update the offset so that
    // data isn't overwritten.
    ctx.off += size_of (T);
}

// Pulls a byte sized array from the code context.
to_byte_array :: proc (ctx: ^Code_Context) -> [] byte {
    return ctx.buf[:ctx.off];
}