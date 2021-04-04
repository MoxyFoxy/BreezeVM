package Numeric_Converters

import "breeze:Types"
import "breeze:Bytecode"

to_u64 :: proc (value: Types.Stack_Type) -> Types.Stack_Type {
    using Types;

    value := value;

    value.type = Bytecode.Type.U64;
    
    #partial switch type in value.variant {
        case Integer:
            return integer_to_u64 (value);

        /*
        case Unsigned_Integer:
            return unsigned_integer_to_u64 (value);
        */

        case:
            // This should never be reached
            // as any other type should not
            // convert to u64.
            unreachable ();
    }
}

unsigned_integer_to_u64 :: proc (value: Types.Stack_Type) -> Types.Stack_Type {
    using Types;

    value := value;

    #partial switch type in value.variant.(Unsigned_Integer) {
        case uint:
            value.variant = cast (Unsigned_Integer) (u64 (value.variant.(Unsigned_Integer).(uint)));

        case u8:
            value.variant = cast (Unsigned_Integer) (u64 (value.variant.(Unsigned_Integer).(u8)));

        case u16:
            value.variant = cast (Unsigned_Integer) (u64 (value.variant.(Unsigned_Integer).(u16)));

        case u32:
            value.variant = cast (Unsigned_Integer) (u64 (value.variant.(Unsigned_Integer).(u32)));

        case u64:
            value.variant = cast (Unsigned_Integer) (u64 (value.variant.(Unsigned_Integer).(u64)));

        case:
            unreachable ();
    }

    return value;
}

integer_to_u64 :: proc (value: Types.Stack_Type) -> Types.Stack_Type {
    using Types;

    value := value;

    #partial switch type in value.variant.(Integer) {
        case i64:
            value.variant = cast (Unsigned_Integer) (u64 (value.variant.(Integer).(i64)));

        case:
            unreachable ();
    }

    return value;
}