package Types

Header :: struct {
    header_length: u64,

    procedures: [] Procedure, // Each procedure within the bytecode.
    imports   : [] string,    // Names of packages to import.

    shared_imports: [] string, // Names of shared libraries to import.

    data: [] byte, // Extra data for the program to use, such as read-only constant strings. Will ALWAYS import the SBI (standard bytecode interface)
}

Procedure :: struct {
    loc: u64,

    name    : string,
    num_args: u64,
    num_rets: u64,
}