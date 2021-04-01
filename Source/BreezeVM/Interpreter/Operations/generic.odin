package Operations

import "breeze:Types"
import "breeze:State"

import "core:fmt"

get_prep_vals :: #force_inline proc (state: ^State.Interpreter_State) -> [dynamic] Types.Stack_Type {
    return state.scope.block.prep_vals;
}

delete_scope :: #force_inline proc (scope: ^State.Scope) {
    delete_all_blocks (scope.block);
    free (scope);
}

delete_all_blocks :: proc (block: ^State.Block) {
    block := block;

    // TODO: Fix segfault here
    for block != nil {
        next_block := block.parent;

        delete (block.prep_vals);
        free   (block);

        block = next_block;
    }
}

delete_block :: #force_inline proc (block: ^State.Block) {
    delete (block.prep_vals);
    free   (block);
}