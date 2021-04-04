package Interpreter

import "assembler:HeaderOutput"

import "breeze:State"
import "breeze:Types"
import "breeze:Bytecode"
import "breeze:Interpreter/Operations"
import "breeze:Interpreter/Converters/Numeric"

copy :: proc (state: ^State.Interpreter_State, origin, dest: u64) {
    set_value (state, dest, value_at (state, origin));
}

const_to :: proc (state: ^State.Interpreter_State, data_off, stack_off: u64) {
    set_value (state, stack_off, HeaderOutput.header_type_to_stack_type (state, state.data [data_off]));
}

pull_to :: proc (state: ^State.Interpreter_State, prep_off, stack_off: u64) {
    set_value (state, stack_off, get_prep_vals (state) [prep_off]);
}

arg_to :: proc (state: ^State.Interpreter_State, arg_off, stack_off: u64) {
    set_value (state, stack_off, state.scope.parent.block.prep_vals [arg_off]);
}

add_o :: proc (state: ^State.Interpreter_State, stack_off_1, stack_off_2: u64) {
    op_type := get_operation_type (state, value_at (state, stack_off_1));

    #partial switch op_type {
        case .Unknown:
            // This will never be reached.
            unreachable ();
        case .Numeric:
            output := Operations.add_numeric ([] Types.Stack_Type {value_at (state, stack_off_1), value_at (state, stack_off_2)});
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

sub_o :: proc (state: ^State.Interpreter_State, stack_off_1, stack_off_2: u64) {
    op_type := get_operation_type (state, value_at (state, stack_off_1));

    #partial switch op_type {
        case .Unknown:
            // This will never be reached.
            unreachable ();
        case .Numeric:
            append (&state.scope.block.prep_vals, Operations.sub_numeric ([] Types.Stack_Type {value_at (state, stack_off_1), value_at (state, stack_off_2)}));

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

mul_o :: proc (state: ^State.Interpreter_State, stack_off_1, stack_off_2: u64) {
    op_type := get_operation_type (state, value_at (state, stack_off_1));

    #partial switch op_type {
        case .Unknown:
            // This will never be reached.
            unreachable ();
        case .Numeric:
            append (&state.scope.block.prep_vals, Operations.mul_numeric ([] Types.Stack_Type {value_at (state, stack_off_1), value_at (state, stack_off_2)}));

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

div_o :: proc (state: ^State.Interpreter_State, stack_off_1, stack_off_2: u64) {
    op_type := get_operation_type (state, value_at (state, stack_off_1));

    #partial switch op_type {
        case .Unknown:
            // This will never be reached.
            unreachable ();
        case .Numeric:
            append (&state.scope.block.prep_vals, Operations.div_numeric ([] Types.Stack_Type {value_at (state, stack_off_1), value_at (state, stack_off_2)}));

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

mod_o :: proc (state: ^State.Interpreter_State, stack_off_1, stack_off_2: u64) {
    op_type := get_operation_type (state, value_at (state, stack_off_1));

    #partial switch op_type {
        case .Unknown:
            // This will never be reached.
            unreachable ();
        case .Numeric:
            append (&state.scope.block.prep_vals, Operations.mod_numeric ([] Types.Stack_Type {value_at (state, stack_off_1), value_at (state, stack_off_2)}));

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

equal_o :: proc (state: ^State.Interpreter_State, stack1, stack2: u64) {
    val1 := value_at (state, stack1);
    val2 := value_at (state, stack2);

    bool_val := Operations.compare (val1, val2) == Operations.EQUAL;

    append (&state.scope.block.prep_vals, Types.Stack_Type {
        size_of (bool),

        Bytecode.Type.Bool,

        cast (Types.Stack_Variant)
            cast (Types.Boolean)
                cast (bool)
                    bool_val,
    });
}

greater_o :: proc (state: ^State.Interpreter_State, stack1, stack2: u64) {
    val1 := value_at (state, stack1);
    val2 := value_at (state, stack2);

    bool_val := Operations.compare (val1, val2) == Operations.GREATER;

    append (&state.scope.block.prep_vals, Types.Stack_Type {
        size_of (bool),

        Bytecode.Type.Bool,

        cast (Types.Stack_Variant)
            cast (Types.Boolean)
                cast (bool)
                    bool_val,
    });
}

lesser_equal_o :: proc (state: ^State.Interpreter_State, stack1, stack2: u64) {
    val1 := value_at (state, stack1);
    val2 := value_at (state, stack2);

    comparison := Operations.compare (val1, val2);
    bool_val   := comparison == Operations.LESSER || comparison == Operations.EQUAL;

    append (&state.scope.block.prep_vals, Types.Stack_Type {
        size_of (bool),

        Bytecode.Type.Bool,

        cast (Types.Stack_Variant)
            cast (Types.Boolean)
                cast (bool)
                    bool_val,
    });
}