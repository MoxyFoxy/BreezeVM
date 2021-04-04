package Intrinsics

import "breeze:State"
import "breeze:Types"
import "breeze:Bytecode"

import FMT "core:fmt"
import Strings "core:strings"

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

        // Yet again, don't remove!
        // This somehow gets the if
        // statement to work...
        // Idk how. Another
        // load-bearing statement.
        value := value;

        if (value.type == Bytecode.Type.String) {
            FMT.println (Strings.string_from_ptr (cast (^byte) value.variant.(Types.String), int (value.len)));
        }

        else {
            FMT.println (value.variant);
        }
    }
}