package State

import "breeze:State/HeaderParser"
import "breeze:Bytecode"
import "breeze:Types"

STACK_SIZE :: 1024 /** 2048*/ / size_of (Types.Stack_Type); // 2 MB

Interpreter_State :: struct {
    procs   : map [string] Types.Procedure,
    dyn_imps: [] string,
    data    : [] Types.Header_Type,
    ro      : [] byte,

    bytecode: [] byte,
    instruction_ptr: u64,

    stack: [STACK_SIZE] byte,
}

initialize :: proc (input: [] byte) -> Interpreter_State {
    parse_ctx, procs, imps, data, ro, bytecode := HeaderParser.get_data (input);

    return Interpreter_State {
        procs,
        imps,
        data,
        ro,
        bytecode, 0,

        [STACK_SIZE] byte {},
    };
}