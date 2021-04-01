package Interpreter

import "breeze:State"
import "breeze:Types"
import "breeze:Bytecode"
import "breeze:Interpreter/Operations"
import "breeze:Interpreter/Converters/Numeric"

import FMT "core:fmt"

pull :: proc (state: ^State.Interpreter_State) {
    off := state.scope.largest_stack_pos;

    FMT.printf ("prep_vals: {0}\n", state.scope.block.prep_vals);

    for val, i in state.scope.block.prep_vals {
        set_value (state, u64 (i + int (off)), val);
    }
}

_delete :: proc (state: ^State.Interpreter_State) {
    clear (&state.scope.block.prep_vals);
}

pull_delete :: proc (state: ^State.Interpreter_State) {
    pull (state);

    clear (&state.scope.block.prep_vals);
}

// Not an instruction.
get_operation_type :: proc (state: ^State.Interpreter_State) -> Types.Operation_Type {
    prep_val_type := state.scope.block.prep_vals [0].type;

    type := Types.Operation_Type.Unknown;

    if (prep_val_type >= Bytecode.Type.Unsigned_Integer && prep_val_type <= Bytecode.Type.F64 || prep_val_type == Bytecode.Type.Pointer) {
        type = Types.Operation_Type.Numeric;
    }

    else if (prep_val_type == Bytecode.Type.String) {
        type = Types.Operation_Type.String;
    }

    else if (prep_val_type == Bytecode.Type.Array) {
        type = Types.Operation_Type.Array;
    }

    else if (prep_val_type == Bytecode.Type.Byte_Object) {
        type = Types.Operation_Type.Byte_Object;
    }

    assert (type != Types.Operation_Type.Unknown, "Unknown Operation Type.");

    return type;
}

add_multi_o :: proc (state: ^State.Interpreter_State) {
    op_type := get_operation_type (state);

    #partial switch op_type {
        case .Unknown:
            // This will never be reached.
            unreachable ();
        case .Numeric:
            output := Operations.add_numeric (state.scope.block.prep_vals [:]);
            clear (&state.scope.block.prep_vals);
            append (&state.scope.block.prep_vals, output);

        /*
        case .String:
            add_string (values);
        case .Array:
            add_array (values);
        case .Byte_Object:
            // TODO: Will only be done if there is time.
        */
    }
}

sub_multi_o :: proc (state: ^State.Interpreter_State) {
    op_type := get_operation_type (state);

    #partial switch op_type {
        case .Unknown:
            // This will never be reached.
            unreachable ();
        case .Numeric:
            clear (&state.scope.block.prep_vals);

            append (&state.scope.block.prep_vals, Operations.sub_numeric (state.scope.block.prep_vals [:]));

        /*
        case .String:
            add_string (values);
        case .Array:
            add_array (values);
        case .Byte_Object:
            // TODO: Will only be done if there is time.
        */
    }
}

mul_multi_o :: proc (state: ^State.Interpreter_State) {
    op_type := get_operation_type (state);

    #partial switch op_type {
        case .Unknown:
            // This will never be reached.
            unreachable ();
        case .Numeric:
            clear (&state.scope.block.prep_vals);

            append (&state.scope.block.prep_vals, Operations.mul_numeric (state.scope.block.prep_vals [:]));

        /*
        case .String:
            add_string (values);
        case .Array:
            add_array (values);
        case .Byte_Object:
            // TODO: Will only be done if there is time.
        */
    }
}

div_multi_o :: proc (state: ^State.Interpreter_State) {
    op_type := get_operation_type (state);

    #partial switch op_type {
        case .Unknown:
            // This will never be reached.
            unreachable ();
        case .Numeric:
            clear (&state.scope.block.prep_vals);

            append (&state.scope.block.prep_vals, Operations.div_numeric (state.scope.block.prep_vals [:]));

        /*
        case .String:
            add_string (values);
        case .Array:
            add_array (values);
        case .Byte_Object:
            // TODO: Will only be done if there is time.
        */
    }
}

mod_multi_o :: proc (state: ^State.Interpreter_State) {
    op_type := get_operation_type (state);

    #partial switch op_type {
        case .Unknown:
            // This will never be reached.
            unreachable ();
        case .Numeric:
            clear (&state.scope.block.prep_vals);

            append (&state.scope.block.prep_vals, Operations.mod_numeric (state.scope.block.prep_vals [:]));

        /*
        case .String:
            add_string (values);
        case .Array:
            add_array (values);
        case .Byte_Object:
            // TODO: Will only be done if there is time.
        */
    }
}