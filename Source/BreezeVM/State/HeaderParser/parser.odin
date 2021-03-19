package HeaderParser

import "breeze:Types"

Parser_Context :: struct {
    input: [] byte,

    off: u64,

    len_head      : u64, // Length of the header.
    len_proc_descs: u64, // Length of the procedure descriptors.
    len_dyn_imps  : u64, // Length of the shared imports (dyn => dynamic).
    len_data_descs: u64, // Length of the data descriptors.
    len_ro_data   : u64, // Length of the read-only data.
    len_bytecode  : u64, // Length of the bytecode.

    proc_descs_amt: u64, // Amount of procedure descriptors
    dyn_imps_amt  : u64, // Amount of shared imports (dyn => dynamic).
    data_descs_amt: u64, // Amount of data descriptors.

    bytecode: [] byte,
}

get_data :: proc (input: [] byte) -> (Parser_Context, map [string] Types.Procedure, [] string, [] Types.Header_Type, [] byte, [] byte) {
    ctx := Parser_Context {
        input,

        0,

        0, 0, 0, 0, 0, 0,

        0, 0, 0,

        nil,
    };

    set_header_len (&ctx);

    set_proc_descs_amt      (&ctx);
    set_proc_descs_len      (&ctx);
    procs := get_proc_descs (&ctx);

    set_dyn_imps_amt     (&ctx);
    set_dyn_imps_len     (&ctx);
    imps := get_dyn_imps (&ctx);

    set_data_descs_amt     (&ctx);
    set_data_descs_len     (&ctx);
    data := get_data_descs (&ctx);

    set_ro_data_len   (&ctx);
    ro := get_ro_data (&ctx);

    set_bytecode_len         (&ctx);
    bytecode := get_bytecode (&ctx);

    return ctx, procs, imps, data, ro, bytecode;
}