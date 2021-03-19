package BreezeVM

import "breeze:State"

import OS  "core:os"
import FMT "core:fmt"

main :: proc () {
    input, ok := OS.read_entire_file (OS.args[1]);

    if !ok {
        FMT.printf ("Error loading file \"{0}\".\n", OS.args[1]);
        OS.exit (1);
    }

    state := State.initialize (input);
    FMT.println (state);
}