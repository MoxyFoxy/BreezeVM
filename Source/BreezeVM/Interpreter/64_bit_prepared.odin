package Interpreter

import "breeze:State"
import "breeze:Types"
import "breeze:Bytecode"
import "breeze:Intrinsics"
import "breeze:Interpreter/Operations"

import FMT "core:fmt"

jmpif :: proc (state: ^State.Interpreter_State, offset: u64) {
    value := state.scope.block.prep_vals [0];

    if (Operations.is_true (value)) do jmp (state, offset);
}

call_o :: proc (state: ^State.Interpreter_State, code: u64) {
    Intrinsics.PROC_TABLE [code] (state);
}

call_proc_o :: proc (state: ^State.Interpreter_State, off: u64) {
    procedure := state.procs [off];

    assert (u64 (len (state.scope.block.prep_vals)) == procedure.num_args, FMT.aprintf ("Procedure {0} required {1} arguments, but {2} were passed.", procedure.name, procedure.num_args, len (state.scope.block.prep_vals)));

    state.exit = new (State.Exit_State);
    state.exit^ = State.Exit_State {
        state.exit,
        state.scope,
        state.instruction_ptr,
    };

    state.instruction_ptr = procedure.loc;
    state.iterate = false;
}