package State

import "breeze:State/HeaderParser"
import "breeze:Bytecode"
import "breeze:Types"

STACK_SIZE :: 2048 / size_of (Types.Stack_Type); // 2KB

Interpreter_State :: struct {
    procs   : [] Types.Procedure,
    dyn_imps: [] string,
    data    : [] Types.Header_Type,
    ro      : [] byte,

    bytecode: [] byte,
    instruction_ptr: u64,
    iterate: bool,

    scope: ^Scope,

    exit: ^Exit_State,

    stack: [STACK_SIZE] Types.Stack_Type,
}

Exit_State :: struct {
    parent: ^Exit_State,
    scope: ^Scope,
    exit_off: u64, // Where to return to / exit to next
}

Scope :: struct {
    parent: ^Scope,

    off: u64, // Stack offset
    largest_stack_pos: u64,

    block: ^Block,
}

Block :: struct {
    parent: ^Block,

    prep_vals: [dynamic] Types.Stack_Type,
}

initialize :: proc (input: [] byte) -> Interpreter_State {
    parse_ctx, procs, imps, data, ro, bytecode := HeaderParser.get_data (input);

    return Interpreter_State {
        procs,
        imps,
        data,
        ro,
        bytecode, 0, true,

        nil, nil,

        [STACK_SIZE] Types.Stack_Type {},
    };
}