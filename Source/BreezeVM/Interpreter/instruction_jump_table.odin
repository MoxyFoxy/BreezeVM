package Interpreter

import "breeze:Bytecode"
import "breeze:State"

_NO_BIT_INSTRUCTION_JUMP_TABLE := #partial [Bytecode.Instruction] (proc (state: ^State.Interpreter_State)) {
    
    // Invalid instructions
    .INVALID = invalid,

    // No-bit instructions
    .EXIT = exit,
    .RETURN = ret,
    .PUSH_SCOPE = push_scope,
    .POP_SCOPE = pop_scope,
    .PUSH_BLOCK = push_block,
    .POP_BLOCK = pop_block,
    .HALT = halt,

    // No-bit multi-value instructions
    .PULL = pull,
    .DELETE = _delete,
    .PULL_DELETE = pull_delete,
    .ADD_MULTI_O = add_multi_o,
    .SUB_MULTI_O = sub_multi_o,
    .MUL_MULTI_O = mul_multi_o,
    .DIV_MULTI_O = div_multi_o,
    .MOD_MULTI_O = mod_multi_o,
    // .EXP_MULTI_O = exp_multi_o,

    // No-bit prepared-value instructions have been skipped.
};

_64_BIT_INSTRUCTION_JUMP_TABLE := #partial [Bytecode.Instruction] (proc (state: ^State.Interpreter_State, param: u64)) {
    
    // 64-bit instructions
    .PREPARE_O = prepare_o,
    .PREPARE_CONST_O = prepare_const_o,
    .JMP = jmp,
    .REF_O = ref_o,

    .CALL_PROC_O = call_proc_o,

    // 64-bit prepared instructions
    .JMPIF = jmpif,
};

_128_BIT_INSTRUCTION_JUMP_TABLE := #partial [Bytecode.Instruction] (proc (state: ^State.Interpreter_State, param1, param2: u64)) {
    .CONST_TO = const_to,
    .PULL_TO = pull_to,
    .ADD_O = add_o,
    .SUB_O = sub_o,
    .MUL_O = mul_o,
    .DIV_O = div_o,
    .MOD_O = mod_o,
    .GREATER_O = greater_o,
};

invalid :: proc (state: ^State.Interpreter_State) { assert (false, "An invalid instruction was reached."); }