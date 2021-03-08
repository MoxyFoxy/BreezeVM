package Lexer

import "breeze:Bytecode"
import "breeze:Types"

import Reflect "core:reflect"
import FMT     "core:fmt"

get_import_name :: proc (ctx: ^Lexer_Context) -> string {

    // Eat `IMPORT`
    eat_non_whitespace (ctx);

    return get_word (ctx);
}
/*
get_constant :: proc (ctx: ^Lexer_Context) -> Types.Stack_Type {

    // Eat `CONST`
    eat_non_whitespace (ctx);

    raw_type := get_word (ctx);

    raw_value := "";

    if (peek (ctx) == '"') do raw_value = get_string (ctx);
    if (peek (ctx) != '"') do raw_value = get_word   (ctx);

    type, ok := Reflect.enum_from_name (Bytecode.Type, raw_type);

    if !ok {
        delete (raw_type );
        delete (raw_value);

        append (&ctx.errors, FMT.aprintf ("Type at line {0}, offset {1}, is not a valid type.", ctx.line, ctx.line_off));
    }

    output := Types.Stack_Type{};

    #partial switch type {
        case Bytecode.Type.String:
            output = Stack.create_string (raw_value);

        case Bytecode.Type.Integer:
            output = Stack.create_integer (raw_value);

        case Bytecode.Type.Unsigned_Integer:
            output = Stack.create_unsigned_integer (raw_value);

        case Bytecode.Type.Float:
            output = Stack.create_float (raw_value);

        case Bytecode.Type.Boolean:
            output = Stack.create_boolean (raw_value);

        case:
            append (&ctx.errors, FMT.aprintf ("Type at line {0}, offset {1}, is not a valid type.", ctx.line, ctx.line_off));
    }

    delete (raw_type );
    delete (raw_value);

    return output;
}*/