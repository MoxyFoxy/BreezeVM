package HeaderOutput

import "assembler:Lexer"

import "breeze:State"
import "breeze:Types"
import "breeze:Bytecode"

import Reflect "core:reflect"
import FMT "core:fmt"

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
                    case Bytecode.Type.Uint:
                        write_to_header_context (head_ctx, constant.variant.(Types.Unsigned_Integer).(uint));

                    case Bytecode.Type.U8:
                        write_to_header_context (head_ctx, constant.variant.(Types.Unsigned_Integer).(u8));

                    case Bytecode.Type.U16:
                        write_to_header_context (head_ctx, constant.variant.(Types.Unsigned_Integer).(u16));

                    case Bytecode.Type.U32:
                        write_to_header_context (head_ctx, constant.variant.(Types.Unsigned_Integer).(u32));

                    case Bytecode.Type.U64:
                        write_to_header_context (head_ctx, constant.variant.(Types.Unsigned_Integer).(u64));

                    case Bytecode.Type.Int:
                        write_to_header_context (head_ctx, constant.variant.(Types.Integer).(int));

                    case Bytecode.Type.I8:
                        write_to_header_context (head_ctx, constant.variant.(Types.Integer).(i8));

                    case Bytecode.Type.I16:
                        write_to_header_context (head_ctx, constant.variant.(Types.Integer).(i16));

                    case Bytecode.Type.I32:
                        write_to_header_context (head_ctx, constant.variant.(Types.Integer).(i32));

                    case Bytecode.Type.I64:
                        write_to_header_context (head_ctx, constant.variant.(Types.Integer).(i64));

                    case Bytecode.Type.F32:
                        write_to_header_context (head_ctx, constant.variant.(Types.Float).(f32));

                    case Bytecode.Type.F64:
                        write_to_header_context (head_ctx, constant.variant.(Types.Float).(f64));

                    case Bytecode.Type.Bool:
                        write_to_header_context (head_ctx, constant.variant.(Types.Boolean).(bool));
                }

            }
    }
}

stack_type_to_header_type :: #force_inline proc (ctx: ^Header_Context, type: Types.Stack_Type) -> Types.Header_Type {
    return Types.Header_Type {
        type.len,
        u64 (len (ctx.ro_buf)),
        type.type,
    };
}

header_type_to_stack_type :: #force_inline proc (state: ^State.Interpreter_State, type: Types.Header_Type) -> Types.Stack_Type {
    final := Types.Stack_Type {
        type.len,
        type.type,

        Types.Stack_Variant {}
    };

    #partial switch type.type {
        case Bytecode.Type.String     : final.variant = cast (Types.Stack_Variant) (cast (Types.String)      &state.ro [type.val_off]);
        case Bytecode.Type.Array      : final.variant = cast (Types.Stack_Variant) (cast (Types.Array)       &state.ro [type.val_off]);
        case Bytecode.Type.Byte_Object: final.variant = cast (Types.Stack_Variant) (cast (Types.Byte_Object) &state.ro [type.val_off]);

        case Bytecode.Type.Uint: final.variant = cast (Types.Stack_Variant) (cast (Types.Unsigned_Integer) (cast (^uint) &state.ro [type.val_off])^);
        case Bytecode.Type.U8  : final.variant = cast (Types.Stack_Variant) (cast (Types.Unsigned_Integer) (cast (^u8)   &state.ro [type.val_off])^);
        case Bytecode.Type.U16 : final.variant = cast (Types.Stack_Variant) (cast (Types.Unsigned_Integer) (cast (^u16)  &state.ro [type.val_off])^);
        case Bytecode.Type.U32 : final.variant = cast (Types.Stack_Variant) (cast (Types.Unsigned_Integer) (cast (^u32)  &state.ro [type.val_off])^);
        case Bytecode.Type.U64 : final.variant = cast (Types.Stack_Variant) (cast (Types.Unsigned_Integer) (cast (^u64)  &state.ro [type.val_off])^);

        case Bytecode.Type.Int: final.variant = cast (Types.Stack_Variant) (cast (Types.Integer) (cast (^int) &state.ro [type.val_off])^);
        case Bytecode.Type.I8 : final.variant = cast (Types.Stack_Variant) (cast (Types.Integer) (cast (^i8)  &state.ro [type.val_off])^);
        case Bytecode.Type.I16: final.variant = cast (Types.Stack_Variant) (cast (Types.Integer) (cast (^i16) &state.ro [type.val_off])^);
        case Bytecode.Type.I32: final.variant = cast (Types.Stack_Variant) (cast (Types.Integer) (cast (^i32) &state.ro [type.val_off])^);
        case Bytecode.Type.I64: final.variant = cast (Types.Stack_Variant) (cast (Types.Integer) (cast (^i64) &state.ro [type.val_off])^);
    
        case Bytecode.Type.F32: final.variant = cast (Types.Stack_Variant) (cast (Types.Float) (cast (^f32) &state.ro [type.val_off])^);
        case Bytecode.Type.F64: final.variant = cast (Types.Stack_Variant) (cast (Types.Float) (cast (^f64) &state.ro [type.val_off])^);
    }

    return final;
}