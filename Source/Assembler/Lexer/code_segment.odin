package Lexer

import "breeze:Bytecode"

import FMT     "core:fmt"
import Reflect "core:reflect"
import Strings "core:strings"
import Strconv "core:strconv"

// Gets an instruction value from the lexer context.
get_instruction :: proc (ctx: ^Lexer_Context) -> Bytecode.Instruction {

    // This'll be used later to create an
    // enumeration value from.
    builder := Strings.make_builder ();

    eat_whitespace (ctx);

    char := peek (ctx);

    // Append until we hit whitespace.
    for ((!Strings.is_space (char) || len (Strings.to_string (builder)) == 0) && ctx.byte_off < u64 (len (ctx.input))) {

        // This *specific* `eat`
        // position is necessary
        // or else the assembler
        // won't get the final
        // character.
        char = eat (ctx);

        Strings.write_rune_builder (&builder, char);

        char = peek (ctx);
    }

    // Make an uppercase version of the string
    instruction_str := Strings.to_upper (Strings.to_string (builder));

    // Check to see if it is a multi-instruction variant of a normal instruction.
    if (instruction_str [len (instruction_str) - 2: len (instruction_str)] == "_M") {
        Strings.write_string (&builder, "ULTI_O");

        delete (instruction_str);

        // Make an uppercase version of the string
        instruction_str = Strings.to_upper (Strings.to_string (builder));
    }

    instruction, ok := Reflect.enum_from_name (Bytecode.Instruction, instruction_str);
    
    // Early exit.
    if ok { Strings.destroy_builder (&builder); delete (instruction_str); return instruction; }

    // Check to see if it is an instruction that outputs to prepared values.
    Strings.write_string (&builder, "_O");

    // Make an uppercase version of the string
    instruction_str = Strings.to_upper (Strings.to_string (builder));

    instruction, ok = Reflect.enum_from_name (Bytecode.Instruction, instruction_str);

    // Early exit.
    if ok { Strings.destroy_builder (&builder); delete (instruction_str); return instruction; }

    // For now, this means that there are no more possible instructions. May change in the future.
    append (&ctx.errors, FMT.aprintf ("Instruction at line {0} is not a valid instruction.", ctx.line));

    // Make sure to pick up after yourself!
    // No littering!
    Strings.destroy_builder (&builder);
    delete (instruction_str);

    return Bytecode.Instruction.INVALID;
}

// Gets a value from the lexer context.
get_value :: proc (ctx: ^Lexer_Context) -> u64 {

    eat_whitespace (ctx);

    // So this line is a bit packed.
    // 
    // We first get the byte offset for a slice, then find the next whitespace
    // character, using its offset as the end position of the slice, then
    // we parse the u64 value.
    value, ok := Strconv.parse_i64 (ctx.input [ctx.byte_off : ctx.byte_off + get_next_whitespace_byte_offset (ctx)]);

    eat_non_whitespace (ctx);

    if ok do return transmute (u64) value;

    // This is only ran if it does not early-exit.
    append (&ctx.errors, FMT.aprintf ("Value at line {0}, offset {1}, is not a valid value.", ctx.line, ctx.line_off));

    return 0;
}

// Gets a type from the lexer context.
get_type :: proc (ctx: ^Lexer_Context) -> Bytecode.Type {

    // This'll be used later to create an
    // enumeration value from.
    type_str := get_word (ctx);

    // Since there are no differences from the text to the enum, the string can be passed in directly.
    type, ok := Reflect.enum_from_name (Bytecode.Type, type_str);

    delete (type_str);

    if ok do return type;

    // This is only ran if it does not early-exit.
    append (&ctx.errors, FMT.aprintf ("Type at line {0}, offset {1}, is not a valid type.", ctx.line, ctx.line_off));

    return Bytecode.Type.INVALID;
}

// Gets a procedure's name from the lexer context.
get_proc_name :: proc (ctx: ^Lexer_Context) -> string {

    eat_whitespace (ctx);

    // This will eat the `.` at the beginning.
    char := eat (ctx);

    proc_name := get_word (ctx);

    return proc_name;
}