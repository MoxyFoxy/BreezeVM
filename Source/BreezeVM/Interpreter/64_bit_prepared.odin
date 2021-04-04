package Interpreter

import "breeze:State"
import "breeze:Types"
import "breeze:Bytecode"
import "breeze:Intrinsics"
import "breeze:Interpreter/Operations"

import FMT "core:fmt"

not :: proc (state: ^State.Interpreter_State, offset: u64) {
    value := state.scope.block.prep_vals [offset];

    #partial switch value.type {
        case Bytecode.Type.Bool: value.variant = cast (Types.Stack_Variant) cast (Types.Boolean) !value.variant.(Types.Boolean).(bool);
        case Bytecode.Type.B8  : value.variant = cast (Types.Stack_Variant) cast (Types.Boolean) !value.variant.(Types.Boolean).(b8);
        case Bytecode.Type.B16 : value.variant = cast (Types.Stack_Variant) cast (Types.Boolean) !value.variant.(Types.Boolean).(b16);
        case Bytecode.Type.B32 : value.variant = cast (Types.Stack_Variant) cast (Types.Boolean) !value.variant.(Types.Boolean).(b32);
        case Bytecode.Type.B64 : value.variant = cast (Types.Stack_Variant) cast (Types.Boolean) !value.variant.(Types.Boolean).(b64);
        case: assert (false, FMT.aprintf ("Invalid type ({0}) used in not statement.", value.type));
    }

    state.scope.block.prep_vals [offset] = value;
}

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
        state.instruction_ptr + size_of (Bytecode.Instruction) + size_of (u64),
    };

    state.instruction_ptr = procedure.loc;
    state.iterate = false;
}