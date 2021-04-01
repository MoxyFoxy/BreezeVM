package Interpreter

import "breeze:State"
import "breeze:Types"
import "breeze:Interpreter/Operations"

import OS "core:os"
import FMT "core:fmt"

exit :: proc (state: ^State.Interpreter_State) {

    assert (state.exit != nil, "No exit location was set for an exit.");

    // Get the exit point.
    state.instruction_ptr = state.exit.exit_off;

    curr_scope := state.scope;

    for curr_scope != state.exit.scope {
        next_scope := curr_scope.parent;

        Operations.delete_scope (curr_scope);
        curr_scope = next_scope;
    }
}

ret :: proc (state: ^State.Interpreter_State) {
    assert (state.scope.block != nil, "No block was found for prepared values.");

    // Get the current block, then
    // store the prepared values.
    block     := state.scope.block;
    prep_vals := block.prep_vals;

    // Iterate until we reach the
    // end, deleting them all!
    for block != nil {
        next_block := block.parent;
        
        Operations.delete_block (block);

        block = next_block;
    }

    exit (state);

    assert (state.scope.block != nil, "No block was found to return to.");

    block = state.scope.block;

    delete (block.prep_vals);

    block.prep_vals = prep_vals;

    FMT.println ("Here");
}

push_scope :: proc (state: ^State.Interpreter_State) {
    scope := new (State.Scope);

    scope.parent = state.scope;

    if (state.scope != nil) do scope.off = state.scope.largest_stack_pos + 1;
    
    state.scope = scope;
}

pop_scope :: proc (state: ^State.Interpreter_State) {
    scope := state.scope;

    state.scope = scope.parent;

    if (state.exit != nil) {
        exit := state.exit;

        state.instruction_ptr = exit.exit_off;
        
        state.exit = exit.parent;
    
        free (exit);
    }

    block := scope.block;

    for block != nil {
        new_block := block.parent;

        free (block);

        block = new_block;
    }

    free (scope);
}

push_block :: proc (state: ^State.Interpreter_State) {
    block := new (State.Block);

    block.parent      = state.scope.block;
    block.prep_vals   = make ([dynamic] Types.Stack_Type);
    state.scope.block = block;
}

pop_block :: proc (state: ^State.Interpreter_State) {
    block := state.scope.block;

    delete (block.prep_vals);

    state.scope.block = block.parent;

    free (block);
}

halt :: proc (state: ^State.Interpreter_State) {
    OS.exit (0);
}