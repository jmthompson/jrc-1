The JR/OS system call mechanism uses the COP instruction to make
operating system calls. The signature byte of the COP instruction
holds the function number to be called.

On exit from the system call the accumulator will contain the
result of the call, and the carry will be clear on success and
set on failure. On failure the result will be an error code.

Parameters to system calls can be passed either in the accumulator
(for single byte params), or by pushing a four-byte parameter
pointer onto the stack before making the call. In the latter case
the OS will take care of cleaning up the stack.
