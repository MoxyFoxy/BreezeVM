package HeaderParser

import "breeze:Bytecode"
import "breeze:Types"

import Mem "core:mem"

// Gets a Bytecode.Type.
// 
// This also updates the ctx.off based on the size_of (Bytecode.Type).
get_type :: proc (ctx: ^Parser_Context) -> Bytecode.Type {
    ctx := ctx;

    val := (transmute ([] Bytecode.Type) ctx.input [ctx.off:]) [0];

    ctx.off += size_of (Bytecode.Type);

    return val;
}

// Gets a string through the slight workaround of turning a
// byte pointer into a cstring, then casting to a string.
// 
// This also updates the ctx.off based on the length of the
// string along with one byte of null-terminator.
get_str :: proc (ctx: ^Parser_Context) -> string {
    ctx := ctx;

    val := string (cstring (&ctx.input [ctx.off]));

    ctx.off += u64 (len (val) + 1);

    return val;
}

// Gets all of the procedure descriptors as an array.
get_proc_descs :: proc (ctx: ^Parser_Context) -> [] Types.Procedure {
    proc_descs := make ([] Types.Procedure, ctx.proc_descs_amt);

    for i in 0..<ctx.proc_descs_amt {
        loc  := get_len (ctx);
        name := get_str (ctx);
        args := get_len (ctx);
        rets := get_len (ctx);

        proc_descs [i] = Types.Procedure {loc, name, args, rets};
    }

    return proc_descs;
}

// Gets all of the shared imports as an array (dyn => dynamic.
get_dyn_imps :: proc (ctx: ^Parser_Context) -> [] string {
    shared_imps := make ([] string, ctx.dyn_imps_amt);

    for i in 0..<ctx.dyn_imps_amt {
        shared_imps [i] = get_str (ctx);
    }

    return shared_imps;
}

// Get all of the data descriptors as an array. This does NOT generate
// a new array, it simply slices the input.
get_data_descs :: proc (ctx: ^Parser_Context) -> [] Types.Header_Type {
    ctx := ctx;

    val := Mem.slice_data_cast ([] Types.Header_Type, ctx.input [ctx.off : ctx.off + ctx.len_data_descs]);

    ctx.off += ctx.len_data_descs;

    return val;
}

// Gets all of the read-only data as an array. This does
// NOT generate a new array, it simply slices the input.
get_ro_data :: proc (ctx: ^Parser_Context) -> [] byte {
    return ctx.input [ctx.off : ctx.len_head - size_of (u64)];
}

// Gets all of the bytecode as an array. This does NOT
// generate a new array, it simply slices the input.
get_bytecode :: proc (ctx: ^Parser_Context) -> [] byte {
    return ctx.input [ctx.len_head:];
}