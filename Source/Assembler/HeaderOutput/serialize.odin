package HeaderOutput

import "assembler:Lexer"

import "breeze:Types"
import "breeze:Bytecode"

import Reflect "core:reflect"

iterate :: proc (head_ctx: ^Header_Context, lex_ctx: ^Lexer.Lexer_Context) {
    Lexer.eat_whitespace (lex_ctx);

    if (Lexer.peek (lex_ctx) == ';') {
        Lexer.eat_comment (lex_ctx);
    }

    else {
        write_data_instruction (head_ctx, lex_ctx);
    }
}

write_data_instruction :: proc (head_ctx: ^Header_Context, lex_ctx: ^Lexer.Lexer_Context) {
    Lexer.eat_whitespace (lex_ctx);

    instruction := Lexer.get_data_instruction (lex_ctx);

    #partial switch instruction {
        case Bytecode.DataInstruction.IMPORT:
            Lexer.eat_whitespace (lex_ctx);

            str := Lexer.parse_string (lex_ctx);

            write_import_to_header_context (head_ctx, str);

        case Bytecode.DataInstruction.IMPORT_SHARED:
            Lexer.eat_whitespace (lex_ctx);

            str := Lexer.parse_string (lex_ctx);

            write_import_shared_to_header_context (head_ctx, str);

        case Bytecode.DataInstruction.STORE:
            Lexer.eat_whitespace (lex_ctx);

            constant      := Lexer.get_constant        (lex_ctx);
            constant_head := stack_type_to_header_type (head_ctx, constant);

            write_type_to_header_context (head_ctx, constant_head);

            is_str := constant.type == Bytecode.Type.String;

            if is_str {
                write_string_to_header_context (head_ctx, constant.len, constant.variant.(Types.String));

                return;
            }

            else {
                #partial switch constant.type {
                    case Bytecode.Type.Integer:
                        write_to_header_context (head_ctx, constant.variant.(Types.Integer).(i64));

                    case Bytecode.Type.Unsigned_Integer:
                        write_to_header_context (head_ctx, constant.variant.(Types.Unsigned_Integer).(u64));

                    case Bytecode.Type.Float:
                        write_to_header_context (head_ctx, constant.variant.(Types.Float).(f64));

                    case Bytecode.Type.Boolean:
                        write_to_header_context (head_ctx, constant.variant.(Types.Boolean).(bool));
                }

            }
    }
}

stack_type_to_header_type :: #force_inline proc (ctx: ^Header_Context, type: Types.Stack_Type) -> Types.Header_Type {
    return Types.Header_Type {
        type.len,
        type.type,
        u64 (len (ctx.ro_buf)),
    };
}