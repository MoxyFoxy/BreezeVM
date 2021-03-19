package Assembler

import "assembler:Lexer"
import "assembler:CodeOutput"
import "assembler:HeaderOutput"
import "assembler:BinaryOutput"

import "breeze:Types"

import OS      "core:os"
import FMT     "core:fmt"
import Time    "core:time"
import Runtime "core:runtime"

main :: proc () {

    start := Time.now ();

    // Initialize the contexts necessary.
    code_ctx := CodeOutput  .initialize_code_context   ();
    head_ctx := HeaderOutput.initialize_header_context ();

    error := false;

    for file in OS.args[1:] {
        file_data, ok := OS.read_entire_file (file);

        // Something went wrong when
        // loading the file.
        if !ok {
            FMT.printf ("Error loading file \"{0}\".\n", file);
            continue;
        }

        // Lexer_Context is file-dependent, while Code_Context and Header_Context
        // are not. Therefore, the others are initalized outside of the loop, but
        // the Lexer_Context is initialized within.
        lex_ctx := Lexer.initialize_lexer_context (file, string (file_data));

        // State for checking
        // whether to iterate
        // as CodeOutput or
        // HeaderOutput.
        is_code := true;

        // Iterate for as long as there is no more data in
        // the file.
        for lex_ctx.byte_off < cast (u64) len (file_data) {
            Lexer.eat_whitespace (&lex_ctx);

            // Check for possible DATA or CODE descriptor.
            if (Lexer.peek (&lex_ctx) == '.') {
                
                // We want to peek, not eat, as the dot can also be the
                // name of a procedure.
                potentially_code, ok := Lexer.peek_for_section (&lex_ctx);

                // Simple ternary. Only POTENTIALLY change
                // state if a descriptor was actually found.
                is_code = ok ? potentially_code : is_code;

                // If a descriptor was found,
                // destroy it as it's no longer
                // needed.
                if ok {
                    Lexer.get_word       (&lex_ctx);
                    Lexer.eat_whitespace (&lex_ctx);
                }
            }

            if is_code {
                CodeOutput.iterate (&code_ctx, &lex_ctx);
            }

            else {
                HeaderOutput.iterate (&head_ctx, &lex_ctx);
            }

            // Failsafe in case another procedure
            // doesn't eat whitespace.
            Lexer.eat_whitespace (&lex_ctx);
        }

        if len (lex_ctx.errors) > 0 {
            for error in lex_ctx.errors {
                FMT.println (error);
            }

            error = true;
        }

        // Update the offsets for any additional files.
        head_ctx.last_off    = cast (u64) len (head_ctx.ro_data);
        code_ctx.ro_last_off = cast (u64) len (head_ctx.ro_data);
    }

    // Create the final binary buffer.
    final_bin := BinaryOutput.make_final_binary (&head_ctx, &code_ctx);

    if error do OS.exit (1);

    end := Time.now ();

    duration := Time.diff (start, end);

    FMT.printf ("Completed binary in {0}ms.\n", Time.duration_seconds (duration) * 1e3);

    // Write the binary out to a file.
    OS.write_entire_file ("program.bbc", final_bin[:]);
}

test :: proc () {
    start := Time.now();

    input := `
.PROC 2 0
    PUSH_BLOCK
        PUSH_SCOPE
            PULL_TO 0 0
            PULL_TO 1 1
            ADD 0 1

            PULL_TO 0 0
            PULL_TO 1 1
            SUB 0 1

            PULL_TO 0 0
            PULL_TO 1 1
            MUL 0 1

            PULL_TO 0 0
            PULL_TO 1 1
            DIV 0 1

            PULL_TO 0 0
            PULL_TO 1 1
            MOD 0 1

            PULL_TO 0 0
            PULL_TO 1 1
            EXP 0 1

            CALL 0 ; print_n
        POP_SCOPE
    POP_BLOCK

    HALT
    `;

    test_ctx := Lexer.Lexer_Context {
        "Test",
        input,
        1,
        1,
        0,
        make ([dynamic] string),
    };

    FMT.println (input);

    FMT.print (Lexer.get_proc_name (&test_ctx));
    FMT.print (' ');
    FMT.print (Lexer.get_value     (&test_ctx));
    FMT.print (' ');
    FMT.print (Lexer.get_value     (&test_ctx));
    FMT.print ('\n');

    FMT.println (Lexer.get_instruction (&test_ctx));
    FMT.println (Lexer.get_instruction (&test_ctx));

    for i in 0..<18 {
        FMT.print (Lexer.get_instruction (&test_ctx));
        FMT.print (' ');
        FMT.print (Lexer.get_value       (&test_ctx));
        FMT.print (' ');
        FMT.print (Lexer.get_value       (&test_ctx));
        FMT.print ('\n');
    }

    FMT.print (Lexer.get_instruction (&test_ctx));
    FMT.print (' ');
    FMT.print (Lexer.get_value       (&test_ctx));
    FMT.print ('\n');

    Lexer.eat_comment (&test_ctx);

    FMT.println (Lexer.get_instruction (&test_ctx));
    FMT.println (Lexer.get_instruction (&test_ctx));
    FMT.println (Lexer.get_instruction (&test_ctx));

    end := Time.now();

    duration := Time.diff(start, end);

    FMT.printf ("Milliseconds Elapsed: {0}\n", Time.duration_seconds (duration) * 1e3);
}