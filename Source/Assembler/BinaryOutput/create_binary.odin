package BinaryOutput

import "breeze:Types"

import "assembler:CodeOutput"
import "assembler:HeaderOutput"

import OS      "core:os"
import FMT     "core:fmt"
import Runtime "core:runtime"

make_final_binary :: proc (head_ctx: ^HeaderOutput.Header_Context, code_ctx: ^CodeOutput.Code_Context) -> [] byte {
    
    // Temp storage for the shared imports
    // as we don't know this off the bat.
    imports_shared_buf := make ([dynamic] byte);

    for str in head_ctx.imports_shared {

        // Copy over the string's bytes.
        for _byte in transmute ([] byte) str {
            append (&imports_shared_buf, _byte);
        }

        // Null-terminator
        append (&imports_shared_buf, 0x00);
    }

    // Temp storage for the procedures
    // as we don't know this off the bat.
    procedures_buf := make ([dynamic] byte);

    for _proc in code_ctx.procs {
        _proc := _proc;

        // Copy over the proc's location.
        for i in 0..<size_of (u64) {
            append (&procedures_buf, (transmute (^byte)
                                        (
                                            transmute (uintptr) &_proc.loc +
                                            transmute (uintptr) i
                                        )
                                     )^ // Dereference the "byte pointer", which we transmuted to.
            );
        }

        // Copy over the proc's name.
        for _byte in transmute ([] byte) _proc.name {
            append (&procedures_buf, _byte);
        }

        // Null terminator
        append (&procedures_buf, 0x00);

        // Copy over the proc's number of arguments.
        for i in 0..<size_of (u64) {
            append (&procedures_buf, (transmute (^byte)
                                        (
                                            transmute (uintptr) &_proc.num_args +
                                            transmute (uintptr) i
                                        )
                                     )^ // Dereference the "byte pointer", which we transmuted to.
            );
        }

        // Copy over the proc's number of return values.
        for i in 0..<size_of (u64) {
            append (&procedures_buf, (transmute (^byte)
                                        (
                                            transmute (uintptr) &_proc.num_rets +
                                            transmute (uintptr) i
                                        )
                                     )^ // Dereference the "byte pointer", which we transmuted to.
            );
        }
    }

    final_bin := make (
        [] byte,

        // Indented to explicitly show
        // the continuation of the arguments
        // vs the addition of lengths.

            // Length of a size for
            // the total header size.
            size_of (u64) +

            // Amount of
            // procedure
            // descriptors.
            size_of (u64) +

            // Length of the
            // procedure
            // descriptors.
            size_of (u64) +

            // The space required for
            // storing procedures.
            len (procedures_buf) +

            // Amount of foreign
            // imports.
            size_of (u64) +

            // Length of the
            // foreign imports.
            size_of (u64) +

            // The space required for storing
            // foreign imports.
            len (imports_shared_buf) +

            // Amount of data
            // descriptors.
            size_of (u64) +

            // Length of the
            // data descriptors.
            size_of (u64) +

            // The data required for the read-only data
            // descriptors.
            len (head_ctx.ro_data) * size_of (Types.Header_Type) +

            // Length of the
            // data.
            // 
            // This CAN be
            // computed,
            // but this was
            // kept for the
            // sake of
            // consistency.
            size_of (u64) +
            
            // The data required for
            // the read-only data.
            len (head_ctx.ro_buf) +

            // Length of the
            // bytecode.
            // 
            // Same as before.
            size_of (u64) +

            // The space required for
            // the instructions.
            len (code_ctx.buf),
    );

    // Byte offset that the
    // final binary is on.
    final_bin_off := 0;

    // Copy the header length in bytes.
    header_len := cast (u64) (size_of (u64) * 9 + len (imports_shared_buf) + len (procedures_buf) + len (head_ctx.ro_data) * size_of (Types.Header_Type) + len (head_ctx.ro_buf));
    Runtime.mem_copy (&final_bin[final_bin_off], &header_len, size_of (u64));
    final_bin_off += size_of (u64);

    // Copy the amount of procedures.
    procedures_amt := len (code_ctx.procs);
    Runtime.mem_copy (&final_bin[final_bin_off], &procedures_amt, size_of (u64));
    final_bin_off += size_of (u64);

    // Copy the length of procedures in bytes.
    procedures_buf_len := cast (u64) len (procedures_buf);
    Runtime.mem_copy (&final_bin[final_bin_off], &procedures_buf_len, size_of (u64));
    final_bin_off += size_of (u64);

    // Copy the procedures.
    if (len (procedures_buf) > 0) {
        Runtime.mem_copy (&final_bin[final_bin_off], &procedures_buf[0], len (procedures_buf));
        final_bin_off += len (procedures_buf);
    }

    // Copy the amount of shared / dynamic imports.
    imports_shared_amt := len (head_ctx.imports_shared);
    Runtime.mem_copy (&final_bin[final_bin_off], &imports_shared_amt, size_of (u64));
    final_bin_off += size_of (u64);

    // Copy the length of shared / dynamic imports in bytes.
    imports_shared_len := cast (u64) len (imports_shared_buf);
    Runtime.mem_copy (&final_bin[final_bin_off], &imports_shared_len, size_of (u64));
    final_bin_off += size_of (u64);

    // Copy the shared / dynamic imports.
    if (len (imports_shared_buf) > 0) {
        Runtime.mem_copy (&final_bin[final_bin_off], &imports_shared_buf[0], len (imports_shared_buf));
        final_bin_off += len (imports_shared_buf);
    }

    // Copy the amount of data descriptors.
    ro_data_amt := len (head_ctx.ro_data);
    Runtime.mem_copy (&final_bin[final_bin_off], &ro_data_amt, size_of (u64));
    final_bin_off += size_of (u64);

    // Copy the length of read-only data descriptors in bytes.
    ro_data_len := cast (u64) (len (head_ctx.ro_data) * size_of (Types.Header_Type));
    Runtime.mem_copy (&final_bin[final_bin_off], &ro_data_len, size_of (u64));
    final_bin_off += size_of (u64);

    // Copy the read-only data descriptors.
    if (len (head_ctx.ro_data) > 0) {
        Runtime.mem_copy (&final_bin[final_bin_off], &head_ctx.ro_data[0], cast (int) ro_data_len);
        final_bin_off += cast (int) ro_data_len;
    }

    // Copy the length of the read-only data in bytes.
    ro_buf_len := cast (u64) len (head_ctx.ro_buf);
    Runtime.mem_copy (&final_bin[final_bin_off], &ro_buf_len, size_of (u64));
    final_bin_off += size_of (u64);

    // Copy the read-only data.
    if (len (head_ctx.ro_buf) > 0) {
        Runtime.mem_copy (&final_bin[final_bin_off], &head_ctx.ro_buf[0], len (head_ctx.ro_buf));
        final_bin_off += len (head_ctx.ro_buf);
    }

    // Copy the length of the binary in bytes.
    code_len := cast (u64) len (code_ctx.buf);
    Runtime.mem_copy (&final_bin[final_bin_off], &code_len, size_of (u64));
    final_bin_off += size_of (u64);

    if len (code_ctx.buf) == 0 {
        FMT.println ("ERROR: Code section cannot be empty!");
        OS.exit (1);
    }

    // Copy the binary.
    Runtime.mem_copy (&final_bin[final_bin_off], &code_ctx.buf[0], len (code_ctx.buf));

    return final_bin;
}