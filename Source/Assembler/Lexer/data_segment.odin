package Lexer

import "breeze:Bytecode"
import "breeze:Types"

import FMT     "core:fmt"
import Reflect "core:reflect"
import Strconv "core:strconv"
import Strings "core:strings"

get_import_name :: proc (ctx: ^Lexer_Context) -> string {
    return get_word (ctx);
}

get_data_instruction :: proc (ctx: ^Lexer_Context) -> Bytecode.DataInstruction {
    instruction, ok := Reflect.enum_from_name (Bytecode.DataInstruction, get_word (ctx));

    if ok do return instruction;

    // For now, this means that there are no more possible instructions. May change in the future.
    append (&ctx.errors, FMT.aprintf ("Data instruction at line {0} is not a valid instruction.", ctx.line));

    return Bytecode.DataInstruction.INVALID;
}

get_constant :: proc (ctx: ^Lexer_Context) -> Types.Stack_Type {

    type := get_type (ctx);

    if type == Bytecode.Type.INVALID {
        return Types.Stack_Type{};
    }

    output := Types.Stack_Type{};

    raw_value := parse_unknown_value (ctx);

    #partial switch type {
        case Bytecode.Type.String:
            return Types.Stack_Type {
                cast (u64) len (raw_value),
                Bytecode.Type.String,
                transmute(Types.String) &(transmute ([] byte) raw_value)[0],
            };

        case Bytecode.Type.Uint:
            value, ok := Strconv.parse_u64 (raw_value);

            if !ok {
                append (&ctx.errors, FMT.aprintf ("Value at line {0}, offset {1}, is not a valid value for type {2}.", ctx.line, ctx.line_off, type));

                return Types.Stack_Type{};
            }

            return Types.Stack_Type {
                cast (u64) size_of (uint),
                Bytecode.Type.Uint,
                cast (Types.Unsigned_Integer) cast (uint) value,
            };

        case Bytecode.Type.U8:
            value, ok := Strconv.parse_u64 (raw_value);

            if !ok {
                append (&ctx.errors, FMT.aprintf ("Value at line {0}, offset {1}, is not a valid value for type {2}.", ctx.line, ctx.line_off, type));

                return Types.Stack_Type{};
            }

            return Types.Stack_Type {
                cast (u64) size_of (u8),
                Bytecode.Type.U8,
                cast (Types.Unsigned_Integer) cast (u8) value,
            };

        case Bytecode.Type.U16:
            value, ok := Strconv.parse_u64 (raw_value);

            if !ok {
                append (&ctx.errors, FMT.aprintf ("Value at line {0}, offset {1}, is not a valid value for type {2}.", ctx.line, ctx.line_off, type));

                return Types.Stack_Type{};
            }

            return Types.Stack_Type {
                cast (u64) size_of (u16),
                Bytecode.Type.U16,
                cast (Types.Unsigned_Integer) cast (u16) value,
            };

        case Bytecode.Type.U32:
            value, ok := Strconv.parse_u64 (raw_value);

            if !ok {
                append (&ctx.errors, FMT.aprintf ("Value at line {0}, offset {1}, is not a valid value for type {2}.", ctx.line, ctx.line_off, type));

                return Types.Stack_Type{};
            }

            return Types.Stack_Type {
                cast (u64) size_of (u32),
                Bytecode.Type.U32,
                cast (Types.Unsigned_Integer) cast (u32) value,
            };

        case Bytecode.Type.U64:
            value, ok := Strconv.parse_u64 (raw_value);

            if !ok {
                append (&ctx.errors, FMT.aprintf ("Value at line {0}, offset {1}, is not a valid value for type {2}.", ctx.line, ctx.line_off, type));

                return Types.Stack_Type{};
            }

            return Types.Stack_Type {
                cast (u64) size_of (u64),
                Bytecode.Type.U64,
                cast (Types.Unsigned_Integer) cast (u64) value,
            };

        case Bytecode.Type.Int:
            value, ok := Strconv.parse_i64 (raw_value);

            if !ok {
                append (&ctx.errors, FMT.aprintf ("Value at line {0}, offset {1}, is not a valid value for type {2}.", ctx.line, ctx.line_off, type));

                return Types.Stack_Type{};
            }

            return Types.Stack_Type {
                cast (u64) size_of (int),
                Bytecode.Type.Int,
                cast (Types.Integer) cast (int) value,
            };

        case Bytecode.Type.I8:
            value, ok := Strconv.parse_u64 (raw_value);

            if !ok {
                append (&ctx.errors, FMT.aprintf ("Value at line {0}, offset {1}, is not a valid value for type {2}.", ctx.line, ctx.line_off, type));

                return Types.Stack_Type{};
            }

            return Types.Stack_Type {
                cast (u64) size_of (i8),
                Bytecode.Type.I8,
                cast (Types.Integer) cast (i8) value,
            };

        case Bytecode.Type.I16:
            value, ok := Strconv.parse_u64 (raw_value);

            if !ok {
                append (&ctx.errors, FMT.aprintf ("Value at line {0}, offset {1}, is not a valid value for type {2}.", ctx.line, ctx.line_off, type));

                return Types.Stack_Type{};
            }

            return Types.Stack_Type {
                cast (u64) size_of (i16),
                Bytecode.Type.I16,
                cast (Types.Integer) cast (i16) value,
            };

        case Bytecode.Type.I32:
            value, ok := Strconv.parse_u64 (raw_value);

            if !ok {
                append (&ctx.errors, FMT.aprintf ("Value at line {0}, offset {1}, is not a valid value for type {2}.", ctx.line, ctx.line_off, type));

                return Types.Stack_Type{};
            }

            return Types.Stack_Type {
                cast (u64) size_of (i32),
                Bytecode.Type.I32,
                cast (Types.Integer) cast (i32) value,
            };

        case Bytecode.Type.I64:
            value, ok := Strconv.parse_u64 (raw_value);

            if !ok {
                append (&ctx.errors, FMT.aprintf ("Value at line {0}, offset {1}, is not a valid value for type {2}.", ctx.line, ctx.line_off, type));

                return Types.Stack_Type{};
            }

            return Types.Stack_Type {
                cast (u64) size_of (i64),
                Bytecode.Type.I64,
                cast (Types.Integer) cast (i64) value,
            };

        case Bytecode.Type.F32:
            value, ok := Strconv.parse_f32 (raw_value);

            if !ok {
                append (&ctx.errors, FMT.aprintf ("Value at line {0}, offset {1}, is not a valid value for type {2}.", ctx.line, ctx.line_off, type));

                return Types.Stack_Type{};
            }

            return Types.Stack_Type {
                cast (u64) size_of (f32),
                Bytecode.Type.F32,
                cast (Types.Float) cast (f32) value,
            };

        case Bytecode.Type.F64:
            value, ok := Strconv.parse_f64 (raw_value);

            if !ok {
                append (&ctx.errors, FMT.aprintf ("Value at line {0}, offset {1}, is not a valid value for type {2}.", ctx.line, ctx.line_off, type));

                return Types.Stack_Type{};
            }

            return Types.Stack_Type {
                cast (u64) size_of (f64),
                Bytecode.Type.F64,
                cast (Types.Float) cast (f64) value,
            };

        case Bytecode.Type.Boolean:
            return Types.Stack_Type {
                cast (u64) size_of (bool),
                Bytecode.Type.Boolean,
                cast (Types.Boolean) bool(raw_value[0] == 'T'),
            };

        case:
            append (&ctx.errors, FMT.aprintf ("Type at line {0}, offset {1}, is not a valid type.", ctx.line, ctx.line_off));
            return Types.Stack_Type{};
    }

    return output;
}

parse_unknown_value :: proc (ctx: ^Lexer_Context) -> string {

    eat_whitespace (ctx);

    if (peek (ctx) == '"') do return parse_string (ctx);
    
    return get_word (ctx);
}

parse_string :: proc (ctx: ^Lexer_Context) -> string {

    builder := Strings.make_builder ();

    // Eat quotation mark, then the first character.
    char := eat (ctx);
    char  = eat (ctx);

    for (char != '"') {
        if (char == '\\') {
            char = eat (ctx);

            switch char {
                case 'a' : Strings.write_byte (&builder, 0x07);
                case 'b' : Strings.write_byte (&builder, 0x08);
                case 'e' : Strings.write_byte (&builder, 0x1B);
                case 'f' : Strings.write_byte (&builder, 0x0C);
                case 'n' : Strings.write_byte (&builder, 0x0A);
                case 'r' : Strings.write_byte (&builder, 0x0D);
                case 't' : Strings.write_byte (&builder, 0x09);
                case 'v' : Strings.write_byte (&builder, 0x0B);

                case '\\': Strings.write_rune_builder (&builder, '\\');
                case '"' : Strings.write_rune_builder (&builder, '"' );
            }

            continue;
        }

        Strings.write_rune_builder (&builder, char);

        char = eat (ctx);
    }

    return Strings.to_string (builder);
}