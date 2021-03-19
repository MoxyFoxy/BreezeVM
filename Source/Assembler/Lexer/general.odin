package Lexer

import UTF8    "core:unicode/utf8"
import Strings "core:strings"

Lexer_Context :: struct {
    file_name: string,
    input    : string,
    line     : u64,
    line_off : u64,
    byte_off : u64,
    errors   : [dynamic] string,
}

// Creates a lexer context to pass around the assembler.
initialize_lexer_context :: proc (file_name, input: string) -> Lexer_Context {
    return Lexer_Context {
        file_name, input,
        1, 1, 0,
        make ([dynamic] string),
    };
}

// Eats a character from the lexer context.
eat :: proc (ctx: ^Lexer_Context) -> rune {

    // Shadow to make mutable.
    ctx := ctx;

    // Decode the rune at the byte offset.
    char, len := UTF8.decode_rune (transmute ([] u8) ctx.input [ctx.byte_off:]);

    // Make sure to update the line count
    // if it's a newline.
    if (char == '\n') {
        ctx.line    += 1;
        ctx.line_off = 1;
    }

    // Update the byte offset for the next eat.
    ctx.byte_off += cast (u64) len;

    return char;
}

// Peeks a character from the lexer context.
peek :: proc (ctx: ^Lexer_Context, byte_offset : u64 = 0) -> rune {

    // Shadow to make mutable.
    ctx := ctx;

    // Decode the rune at the byte offset.
    char, _ := UTF8.decode_rune (transmute ([] u8) ctx.input [ctx.byte_off + byte_offset:]);

    return char;
}

// Peeks and returns whether or not
peek_for_section :: proc (ctx: ^Lexer_Context) -> (is_code: bool, ok: bool) {

    eat_whitespace (ctx);
    
    // Shadow to make mutable.
    ctx := ctx;

    // Set up a 5-char buffer for checking
    // a section. Since we know these have
    // to be ASCII, we can safely use a
    // non-rune buffer for the string.
    str: [5] u8;

    // Simple iterator.
    str_off : u64 = 0;

    // Iterate for as long as we haven't reached the end of the input and
    // we haven't reached the end of the buffer.
    for ctx.byte_off < cast (u64) len (ctx.input) && str_off < 5 {
        char := ctx.input [ctx.byte_off + str_off];

        str [str_off] = char;

        str_off += 1;
    }

    // Transmute back to a string to check for the
    // CODE section header.
    is_code = transmute (string) str[:] == ".CODE";

    return
        is_code,

        // If it's code, the check is the fastest
        // since it'll have to check if it's the
        // HEAD section otherwise.
        is_code || transmute (string) str[:] == ".DATA";
}

// Gets the byte offset of the next space-like character.
get_next_whitespace_byte_offset :: proc (ctx: ^Lexer_Context) -> u64 {
    offset : u64 = 0;

    for {
        if (Strings.is_space (peek (ctx, offset)) || ctx.byte_off >= u64(len (ctx.input))) do return offset;

        offset += 1;
    }
}

// Eats all whitespace, stopping at the next non-whitespace character.
eat_whitespace :: proc (ctx: ^Lexer_Context) {

    // Annihilate all whitespace! Destroy those Python peasants!
    // Jk, I'm an avid fan of Python, but please eat all of the
    // whitespace.
    for {
        char := peek (ctx);

        if Strings.is_space (char) { eat (ctx); continue; }

        break;
    }
}

// Eats everything except whitespace, stopping at the next whitespace character.
eat_non_whitespace :: proc (ctx: ^Lexer_Context) {

    // Eat! Consume! Destroy all those pesky words!
    // Reject words! Return to grunts!
    for {
        char := peek (ctx);

        if !Strings.is_space (char) { eat (ctx); continue; }

        break;
    }
}

// Eats a comment from the lexer context.
eat_comment :: proc (ctx: ^Lexer_Context) {
    
    // Semicolon, then first character
    char := eat (ctx);
    char  = eat (ctx);

    for (char != '\n' && ctx.byte_off < u64 (len (ctx.input))) {
        char = eat (ctx);
    }
}

// Gets a word from the lexer context.
get_word :: proc (ctx: ^Lexer_Context) -> string {

    builder := Strings.make_builder ();

    eat_whitespace (ctx);

    char := eat (ctx);

    // Append until we hit whitespace.
    for ((!Strings.is_space (char) || len (Strings.to_string (builder)) == 0) && ctx.byte_off < u64 (len (ctx.input))) {
        Strings.write_rune_builder (&builder, char);

        char = eat (ctx);
    }

    eat_whitespace (ctx);

    return Strings.to_string (builder);
}