package Interpreter

import "breeze:Bytecode"
import "breeze:State"
import "breeze:Types"

import "assembler:HeaderOutput"

prepare_o :: proc (state: ^State.Interpreter_State, offset: u64) {
    append (&state.scope.block.prep_vals, value_at (state, offset));
}

prepare_const_o :: proc (state: ^State.Interpreter_State, offset: u64) {
    append (&state.scope.block.prep_vals, HeaderOutput.header_type_to_stack_type (state, state.data [offset]));
}

jmp :: proc (state: ^State.Interpreter_State, offset: u64) {
    state.instruction_ptr = transmute (u64) (cast (i64) state.instruction_ptr + transmute (i64) offset + size_of (Bytecode.Instruction) + size_of (u64));

    state.iterate = false;
}

ref_o :: proc (state: ^State.Interpreter_State, offset: u64) {
    pointer := cast (Types.Pointer) ref_at (state, u64 (transmute (i64) offset + transmute (i64) state.scope.off));

    append (&state.scope.block.prep_vals, Types.Stack_Type { pointer.len, Bytecode.Type.Pointer, cast (Types.Stack_Variant) pointer, });
}