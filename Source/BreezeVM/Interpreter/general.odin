package Interpreter

import "breeze:State"
import "breeze:Types"

value_at :: #force_inline proc (state: ^State.Interpreter_State, off: u64) -> Types.Stack_Type {
    state.scope.largest_stack_pos = off + state.scope.off > state.scope.largest_stack_pos ? off + state.scope.off : state.scope.largest_stack_pos;

    return state.stack [off + state.scope.off];
}

set_value :: #force_inline proc (state: ^State.Interpreter_State, off: u64, value: Types.Stack_Type) {
    state.scope.largest_stack_pos = off + state.scope.off > state.scope.largest_stack_pos ? off + state.scope.off : state.scope.largest_stack_pos;

    state.stack [off + state.scope.off] = value;
}

ref_at :: #force_inline proc (state: ^State.Interpreter_State, off: u64) -> ^Types.Stack_Type {
    state.scope.largest_stack_pos = off + state.scope.off > state.scope.largest_stack_pos ? off + state.scope.off : state.scope.largest_stack_pos;

    return &state.stack [off + state.scope.off];
}

get_prep_vals :: #force_inline proc (state: ^State.Interpreter_State) -> [] Types.Stack_Type {
    return state.scope.block.prep_vals [:];
}