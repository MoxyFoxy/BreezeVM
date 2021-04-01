package BreezeVM

import "breeze:State"
import "breeze:Bytecode"
import "breeze:Interpreter"

import OS  "core:os"
import FMT "core:fmt"

main :: proc () {
    input, ok := OS.read_entire_file (OS.args[1]);

    if !ok {
        FMT.printf ("Error loading file \"{0}\".\n", OS.args[1]);
        OS.exit (1);
    }

    state := State.initialize (input);

    // For debugging purposes
    FMT.println (state);

    for state.instruction_ptr < u64 (len (state.bytecode)) {

        state.iterate = true;

        instruction := (cast (^Bytecode.Instruction) &state.bytecode [state.instruction_ptr])^;

        // For debugging purposes
        FMT.println (instruction);

        if (_no_bit (instruction)) {
            Interpreter._NO_BIT_INSTRUCTION_JUMP_TABLE [instruction] (&state);

            if state.iterate do state.instruction_ptr += size_of (Bytecode.Instruction);
        }

        else if (_64_bit (instruction)) {
            param := (cast (^u64) (&state.bytecode [state.instruction_ptr + size_of (Bytecode.Instruction)]))^;

            Interpreter._64_BIT_INSTRUCTION_JUMP_TABLE [instruction] (&state, param);

            if state.iterate do state.instruction_ptr += size_of (Bytecode.Instruction) + size_of (u64);
        }

        else if (_128_bit (instruction)) {
            param1 := (cast (^u64) (&state.bytecode [state.instruction_ptr + size_of (Bytecode.Instruction)]))^;
            param2 := (cast (^u64) (&state.bytecode [state.instruction_ptr + size_of (Bytecode.Instruction) + size_of (u64)]))^;

            Interpreter._128_BIT_INSTRUCTION_JUMP_TABLE [instruction] (&state, param1, param2);

            if state.iterate do state.instruction_ptr += size_of (Bytecode.Instruction) + size_of (u64) * 2;
        }
    }

    FMT.println (state);
}

_no_bit :: #force_inline proc (instruction: Bytecode.Instruction) -> bool {
    return instruction < Bytecode.Instruction._RESERVED_NO_BIT_PREPARED_VALUE_INSTRUCTIONS;
}

_64_bit :: #force_inline proc (instruction: Bytecode.Instruction) -> bool {
    return instruction < Bytecode.Instruction._RESERVED_64_BIT_MULTI_VALUE_INSTRUCTIONS;
}

_72_bit :: #force_inline proc (instruction: Bytecode.Instruction) -> bool {
    return instruction < Bytecode.Instruction._RESERVED_72_BIT_INSTRUCTIONS;
}

_128_bit :: #force_inline proc (instruction: Bytecode.Instruction) -> bool {
    return instruction < Bytecode.Instruction._RESERVED_128_BIT_INSTRUCTIONS;
}

_136_bit :: #force_inline proc (instruction: Bytecode.Instruction) -> bool {
    return instruction < Bytecode.Instruction._RESERVED_136_BIT_INSTRUCTIONS;
}