package Numeric_Converters

import "breeze:Types"
import "breeze:Bytecode"

import FMT "core:fmt"

convert :: proc (value: Types.Stack_Type, to_type: Bytecode.Type) -> Types.Stack_Type {
    using Bytecode;

    value := value;

    value.type = Type.U64;

    FMT.println (to_type);

    if (to_type == Type.U64) do return to_u64 (value);
    if (to_type == Type.I64) do return to_i64 (value);
    if (to_type == Type.F64) do return to_f64 (value);

    unreachable ();
}