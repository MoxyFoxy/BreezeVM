package Assembler

import Lexer      "assembler:Lexer"
import CodeOutput "assembler:CodeOutput"

import OS   "core:os"
import FMT  "core:fmt"
import Time "core:time"

main :: proc () {
    // TODO: Header information

    // TODO: Code check

    for file in OS.args[1:] {
        file_data, ok := OS.read_entire_file (file);

        if (!ok) {
            FMT.printf ("Error loading {0}.\n", file);
            continue;
        }

        code_ctx := CodeOutput.initialize_code_context (len (file_data));
        lex_ctx  := Lexer.initialize_lexer_context     (file, string (file_data));

        for (lex_ctx.byte_off < cast (u64) len (file_data)) {
            CodeOutput.iterate (&code_ctx, &lex_ctx);
        }

        FMT.println ("Bytecode output:");
        for i in 0..<code_ctx.off {
            FMT.printf ("%2x ", code_ctx.buf[i]);

            if ((i + 1) % 20 == 0 && i > 0) do FMT.println ();
        }
        FMT.println ();
    }
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