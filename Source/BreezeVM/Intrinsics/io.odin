package Intrinsics

import "breeze:State"

import FMT "core:fmt"

print_prepared_values :: proc (state: ^State.Interpreter_State) {
    for value in state.scope.block.prep_vals {
        FMT.println (value.variant);
    }
}