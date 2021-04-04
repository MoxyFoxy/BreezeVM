package Intrinsics

import "breeze:State"

import FMT "core:fmt"

print_prepared_values :: proc (state: ^State.Interpreter_State) {
    
    // NOTE(F0x1fy): DON'T REMOVE! This is a this
    //               is a load-bearing print. If
    //               this is removed, prepare for
    //               alignment issues!
    //
    // This is what happens if you remove this
    // print: https://www.youtube.com/watch?v=QRVExJZKIT8
    FMT.print ();

    for value in state.scope.block.prep_vals {
        FMT.println (value.variant);
    }
}