package Numeric_Converters

import "breeze:Types"
import "breeze:Bytecode"

to_i64 :: proc (value: Types.Stack_Type) -> Types.Stack_Type {
    using Types;

    value := value;

    value.type = Bytecode.Type.U64;
    
    #partial switch type in value.variant {
        case Unsigned_Integer:
            return unsigned_integer_to_i64 (value);

        /*
        case Integer:
            return integer_to_i64 (value);
        */

        case:
            // This should never be reached
            // as any other type should not
            // convert to u64.
            unreachable ();
    }
}

unsigned_integer_to_i64 :: proc (value: Types.Stack_Type) -> Types.Stack_Type {
    using Types;

    value := value;

    #partial switch type in value.variant.(Unsigned_Integer) {
        case u64:
            value.variant = cast (Integer) (i64 (value.variant.(Unsigned_Integer).(u64)));

        case:
            unreachable ();
    }

    return value;
}