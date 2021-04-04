package Operations

import "breeze:Types"
import "breeze:Bytecode"
import "breeze:Interpreter/Converters/Numeric"

import "core:math"

add_numeric :: proc (values: [] Types.Stack_Type) -> Types.Stack_Type {
    using Bytecode;

    current_type := Type.INVALID;
    final := values [0];

    for val in values [1:] {
        val := val;

        if final.type < val.type {
            final.type = val.type;

            final = Numeric.convert (final, val.type);
        }

        else if final.type > val.type {
            val.type = final.type;

            val = Numeric.convert (val, final.type);
        }

        #partial switch final.type {
            case .Uint: final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(uint) + val.variant.(Types.Unsigned_Integer).(uint));
            case .U8  : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u8)   + val.variant.(Types.Unsigned_Integer).(u8));
            case .U16 : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u16)  + val.variant.(Types.Unsigned_Integer).(u16));
            case .U32 : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u32)  + val.variant.(Types.Unsigned_Integer).(u32));
            case .U64 : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u64)  + val.variant.(Types.Unsigned_Integer).(u64));

            case .Int: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(int) + val.variant.(Types.Integer).(int));
            case .I8 : final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i8)  + val.variant.(Types.Integer).(i8));
            case .I16: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i16) + val.variant.(Types.Integer).(i16));
            case .I32: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i32) + val.variant.(Types.Integer).(i32));
            case .I64: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i64) + val.variant.(Types.Integer).(i64));
        
            case .F32: final.variant = cast (Types.Stack_Variant) cast (Types.Float) (final.variant.(Types.Float).(f32) + val.variant.(Types.Float).(f32));
            case .F64: final.variant = cast (Types.Stack_Variant) cast (Types.Float) (final.variant.(Types.Float).(f64) + val.variant.(Types.Float).(f64));

            case: assert (false, "Incompatible type in addition.");
        }
    }

    return final;
}

sub_numeric :: proc (values: [] Types.Stack_Type) -> Types.Stack_Type {
    using Bytecode;

    current_type := Type.INVALID;
    final := values [0];

    for val in values [1:] {
        val := val;

        if final.type < val.type {
            final.type = val.type;

            final = Numeric.convert (final, val.type);
        }

        else if (final.type > val.type) {
            val.type = final.type;

            val = Numeric.convert (val, final.type);
        }

        #partial switch final.type {
            case .Uint: final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(uint) - val.variant.(Types.Unsigned_Integer).(uint));
            case .U8  : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u8)   - val.variant.(Types.Unsigned_Integer).(u8));
            case .U16 : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u16)  - val.variant.(Types.Unsigned_Integer).(u16));
            case .U32 : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u32)  - val.variant.(Types.Unsigned_Integer).(u32));
            case .U64 : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u64)  - val.variant.(Types.Unsigned_Integer).(u64));

            case .Int: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(int) - val.variant.(Types.Integer).(int));
            case .I8 : final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i8)  - val.variant.(Types.Integer).(i8));
            case .I16: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i16) - val.variant.(Types.Integer).(i16));
            case .I32: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i32) - val.variant.(Types.Integer).(i32));
            case .I64: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i64) - val.variant.(Types.Integer).(i64));
        
            case .F32: final.variant = cast (Types.Stack_Variant) cast (Types.Float) (final.variant.(Types.Float).(f32) - val.variant.(Types.Float).(f32));
            case .F64: final.variant = cast (Types.Stack_Variant) cast (Types.Float) (final.variant.(Types.Float).(f64) - val.variant.(Types.Float).(f64));

            case: assert (false, "Incompatible type in subtraction.");
        }
    }

    return final;
}

mul_numeric :: proc (values: [] Types.Stack_Type) -> Types.Stack_Type {
    using Bytecode;

    current_type := Type.INVALID;
    final := values [0];

    for val in values [1:] {
        val := val;

        if final.type < val.type {
            final.type = val.type;

            final = Numeric.convert (final, val.type);
        }

        else if (final.type > val.type) {
            val.type = final.type;

            val = Numeric.convert (val, final.type);
        }

        #partial switch final.type {
            case .Uint: final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(uint) * val.variant.(Types.Unsigned_Integer).(uint));
            case .U8  : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u8)   * val.variant.(Types.Unsigned_Integer).(u8));
            case .U16 : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u16)  * val.variant.(Types.Unsigned_Integer).(u16));
            case .U32 : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u32)  * val.variant.(Types.Unsigned_Integer).(u32));
            case .U64 : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u64)  * val.variant.(Types.Unsigned_Integer).(u64));

            case .Int: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(int) * val.variant.(Types.Integer).(int));
            case .I8 : final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i8)  * val.variant.(Types.Integer).(i8));
            case .I16: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i16) * val.variant.(Types.Integer).(i16));
            case .I32: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i32) * val.variant.(Types.Integer).(i32));
            case .I64: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i64) * val.variant.(Types.Integer).(i64));
        
            case .F32: final.variant = cast (Types.Stack_Variant) cast (Types.Float) (final.variant.(Types.Float).(f32) * val.variant.(Types.Float).(f32));
            case .F64: final.variant = cast (Types.Stack_Variant) cast (Types.Float) (final.variant.(Types.Float).(f64) * val.variant.(Types.Float).(f64));

            case: assert (false, "Incompatible type in multiplication.");
        }
    }

    return final;
}

div_numeric :: proc (values: [] Types.Stack_Type) -> Types.Stack_Type {
    using Bytecode;

    current_type := Type.INVALID;
    final := values [0];

    for val in values [1:] {
        val := val;

        if final.type < val.type {
            final.type = val.type;

            final = Numeric.convert (final, val.type);
        }

        else if (final.type > val.type) {
            val.type = final.type;

            val = Numeric.convert (val, final.type);
        }

        #partial switch final.type {
            case .Uint: final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(uint) / val.variant.(Types.Unsigned_Integer).(uint));
            case .U8  : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u8)   / val.variant.(Types.Unsigned_Integer).(u8));
            case .U16 : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u16)  / val.variant.(Types.Unsigned_Integer).(u16));
            case .U32 : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u32)  / val.variant.(Types.Unsigned_Integer).(u32));
            case .U64 : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u64)  / val.variant.(Types.Unsigned_Integer).(u64));

            case .Int: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(int) / val.variant.(Types.Integer).(int));
            case .I8 : final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i8)  / val.variant.(Types.Integer).(i8));
            case .I16: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i16) / val.variant.(Types.Integer).(i16));
            case .I32: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i32) / val.variant.(Types.Integer).(i32));
            case .I64: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i64) / val.variant.(Types.Integer).(i64));
        
            case .F32: final.variant = cast (Types.Stack_Variant) cast (Types.Float) (final.variant.(Types.Float).(f32) / val.variant.(Types.Float).(f32));
            case .F64: final.variant = cast (Types.Stack_Variant) cast (Types.Float) (final.variant.(Types.Float).(f64) / val.variant.(Types.Float).(f64));

            case: assert (false, "Incompatible type in division.");
        }
    }

    return final;
}

mod_numeric :: proc (values: [] Types.Stack_Type) -> Types.Stack_Type {
    using Bytecode;

    current_type := Type.INVALID;
    final := values [0];

    for val in values [1:] {
        val := val;

        if final.type < val.type {
            final.type = val.type;

            final = Numeric.convert (final, val.type);
        }

        else if (final.type > val.type) {
            val.type = final.type;

            val = Numeric.convert (val, final.type);
        }

        #partial switch final.type {
            case .Uint: final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(uint) % val.variant.(Types.Unsigned_Integer).(uint));
            case .U8  : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u8)   % val.variant.(Types.Unsigned_Integer).(u8));
            case .U16 : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u16)  % val.variant.(Types.Unsigned_Integer).(u16));
            case .U32 : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u32)  % val.variant.(Types.Unsigned_Integer).(u32));
            case .U64 : final.variant = cast (Types.Stack_Variant) cast (Types.Unsigned_Integer) (final.variant.(Types.Unsigned_Integer).(u64)  % val.variant.(Types.Unsigned_Integer).(u64));

            case .Int: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(int) % val.variant.(Types.Integer).(int));
            case .I8 : final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i8)  % val.variant.(Types.Integer).(i8));
            case .I16: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i16) % val.variant.(Types.Integer).(i16));
            case .I32: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i32) % val.variant.(Types.Integer).(i32));
            case .I64: final.variant = cast (Types.Stack_Variant) cast (Types.Integer) (final.variant.(Types.Integer).(i64) % val.variant.(Types.Integer).(i64));
        
            case .F32: assert (false, "Cannot use float in modulus.");
            case .F64: assert (false, "Cannot use float in modulus.");

            case: assert (false, "Incompatible type in modulus.");
        }
    }

    return final;
}