package HeaderParser

// All of the procedures in this file follow the same exact structure.
// 
// They simply use the `get_len` procedure to get the
// length, then assign it to the context's specific length.

// Gets a length, specified as a u64.
// 
// This also updates the ctx.off based on the size_of (u64).
get_len :: proc (ctx: ^Parser_Context) -> u64 {
    ctx := ctx;

    val := (transmute ([] u64) ctx.input [ctx.off:]) [0];

    ctx.off += size_of (u64);

    return val;
}

// Sets the header length.
set_header_len :: proc (ctx: ^Parser_Context) {
    ctx := ctx;

    ctx.len_head = get_len (ctx);
}

// Sets the Procedure Descriptors length.
set_proc_descs_len :: proc (ctx: ^Parser_Context) {
    ctx := ctx;

    ctx.len_proc_descs = get_len (ctx);
}

// Sets the Foreign Import length (dyn => dynamic).
set_dyn_imps_len :: proc (ctx: ^Parser_Context) {
    ctx := ctx;

    ctx.len_dyn_imps = get_len (ctx);
}

// Sets the Data Descriptors length.
set_data_descs_len :: proc (ctx: ^Parser_Context) {
    ctx := ctx;

    ctx.len_data_descs = get_len (ctx);
}

// Sets the Read-Only Data length.
set_ro_data_len :: proc (ctx: ^Parser_Context) {
    ctx := ctx;

    ctx.len_ro_data = get_len (ctx);
}

// Sets the Bytecode length.
set_bytecode_len :: proc (ctx: ^Parser_Context) {
    ctx := ctx;

    ctx.len_bytecode = get_len (ctx);
}

/* * * * * *\
 * Amounts *
\* * * * * */

// Sets the Procedure Descriptors amount.
set_proc_descs_amt :: proc (ctx: ^Parser_Context) {
    ctx := ctx;

    ctx.proc_descs_amt = get_len (ctx);
}

// Sets the Foreign Import amount (dyn => dynamic).
set_dyn_imps_amt :: proc (ctx: ^Parser_Context) {
    ctx := ctx;

    ctx.dyn_imps_amt = get_len (ctx);
}

// Sets the Data Descriptors amount.
set_data_descs_amt :: proc (ctx: ^Parser_Context) {
    ctx := ctx;

    ctx.data_descs_amt = get_len (ctx);
}