package Operations

import "breeze:Types"
import "breeze:Bytecode"

import MEM "core:mem"

LESSER  :: 0;
GREATER :: 1;
EQUAL   :: 2;
INVALID_COMPARISON :: -1;

compare :: proc (value, other: Types.Stack_Type) -> i8 {
    using Bytecode.Type;

    assert (value.type == other.type, "Incompatible types used.");

    #partial switch value.type {
        case .Pointer:
            return compare (value.variant.(Types.Pointer)^, other.variant.(Types.Pointer)^);

        case .String :

            if (value.len > other.len) do return LESSER;
            if (value.len < other.len) do return GREATER;

            str1 := cast (string) MEM.slice_ptr (cast (^byte) value.variant.(Types.String), cast (int) value.len);
            str2 := cast (string) MEM.slice_ptr (cast (^byte) other.variant.(Types.String), cast (int) other.len);

            if (str1 > str2) do return LESSER;
            if (str1 < str2) do return GREATER;

            return EQUAL;

        case .Array  : assert (false, "Comparisons of arrays is not allowed.");
        case .Byte_Object: assert (false, "Comparisons of byte objects is not allowed.");
    
        case .Uint:

            val1 := value.variant.(Types.Unsigned_Integer).(uint);
            val2 := other.variant.(Types.Unsigned_Integer).(uint);

            if (val1 > val2) do return GREATER;
            if (val1 < val2) do return LESSER;

            return EQUAL;

        case .U8:

            val1 := value.variant.(Types.Unsigned_Integer).(u8);
            val2 := other.variant.(Types.Unsigned_Integer).(u8);

            if (val1 > val2) do return GREATER;
            if (val1 < val2) do return LESSER;

            return EQUAL;

        case .U16:

            val1 := value.variant.(Types.Unsigned_Integer).(u16);
            val2 := other.variant.(Types.Unsigned_Integer).(u16);

            if (val1 > val2) do return GREATER;
            if (val1 < val2) do return LESSER;

            return EQUAL;

        case .U32:

            val1 := value.variant.(Types.Unsigned_Integer).(u32);
            val2 := other.variant.(Types.Unsigned_Integer).(u32);

            if (val1 > val2) do return GREATER;
            if (val1 < val2) do return LESSER;

            return EQUAL;

        case .U64:

            val1 := value.variant.(Types.Unsigned_Integer).(u64);
            val2 := other.variant.(Types.Unsigned_Integer).(u64);

            if (val1 > val2) do return GREATER;
            if (val1 < val2) do return LESSER;

            return EQUAL;

        case .Int:

            val1 := value.variant.(Types.Integer).(int);
            val2 := other.variant.(Types.Integer).(int);

            if (val1 > val2) do return GREATER;
            if (val1 < val2) do return LESSER;

            return EQUAL;

        case .I8:

            val1 := value.variant.(Types.Integer).(i8);
            val2 := other.variant.(Types.Integer).(i8);

            if (val1 > val2) do return GREATER;
            if (val1 < val2) do return LESSER;

            return EQUAL;

        case .I16:

            val1 := value.variant.(Types.Integer).(i16);
            val2 := other.variant.(Types.Integer).(i16);

            if (val1 > val2) do return GREATER;
            if (val1 < val2) do return LESSER;

            return EQUAL;

        case .I32:

            val1 := value.variant.(Types.Integer).(i32);
            val2 := other.variant.(Types.Integer).(i32);

            if (val1 > val2) do return GREATER;
            if (val1 < val2) do return LESSER;

            return EQUAL;

        case .I64:

            val1 := value.variant.(Types.Integer).(i64);
            val2 := other.variant.(Types.Integer).(i64);

            if (val1 > val2) do return GREATER;
            if (val1 < val2) do return LESSER;

            return EQUAL;

        case .F32:

            val1 := value.variant.(Types.Float).(f32);
            val2 := other.variant.(Types.Float).(f32);

            if (val1 > val2) do return GREATER;
            if (val1 < val2) do return LESSER;

            return EQUAL;

        case .F64:

            val1 := value.variant.(Types.Float).(f64);
            val2 := other.variant.(Types.Float).(f64);

            if (val1 > val2) do return GREATER;
            if (val1 < val2) do return LESSER;

            return EQUAL;

        case: return INVALID_COMPARISON;
    }

    // NOTE(F0x1fy): For some reason, it
    // doesn't detect the above default
    // case. Odd indeed.
    return INVALID_COMPARISON;
}

non_zero :: proc (type: Types.Stack_Type) -> bool {
    using Bytecode.Type;

    #partial switch type.type {
        case .Pointer: return type.variant.(Types.Pointer)  != nil;
        case .String : return !(type.variant.(Types.String) == nil || type.len == 0);
        case .Array  : return !(type.variant.(Types.Array)  == nil || type.len == 0);
        case .Byte_Object: return !(type.variant.(Types.Byte_Object)  == nil || type.len == 0);

        case .Uint: return type.variant.(Types.Unsigned_Integer).(uint) != 0;
        case .U8  : return type.variant.(Types.Unsigned_Integer).(u8)   != 0;
        case .U16 : return type.variant.(Types.Unsigned_Integer).(u16)  != 0;
        case .U32 : return type.variant.(Types.Unsigned_Integer).(u32)  != 0;
        case .U64 : return type.variant.(Types.Unsigned_Integer).(u64)  != 0;

        case .Int: return type.variant.(Types.Integer).(int) != 0;
        case .I8 : return type.variant.(Types.Integer).(i8)  != 0;
        case .I16: return type.variant.(Types.Integer).(i16) != 0;
        case .I32: return type.variant.(Types.Integer).(i32) != 0;
        case .I64: return type.variant.(Types.Integer).(i64) != 0;

        case .F32: return type.variant.(Types.Float).(f32) != 0;
        case .F64: return type.variant.(Types.Float).(f64) != 0;

        case: return false;
    }
}

is_true :: proc (type: Types.Stack_Type) -> bool {
    using Bytecode.Type;

    #partial switch type.type {
        case .Bool: return type.variant.(Types.Boolean).(bool);

        case: return non_zero (type);
    }
}