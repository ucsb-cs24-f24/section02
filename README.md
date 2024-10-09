# Instructor notes

This example should teach students the basics of the compiler and its steps (preprocessor, compiler, linker) and how to write a basic Makefile.

This information is prerequisite to lab01 and lab02.

## Compiler

1. Introduce steps of compiler:
    - Preprocessor: processes `#` directives (`#include`, `#define`, `#if`, etc.) Some of these are included in the code. Usually, included files are "header files" (`.h`).
    - Compiler: converts `.cpp` files (NOT `.h` files) to "machine code" (executable or library file).
    - Linker: links multiple machine code "object files" together, resolving dependencies on external functions.
2. Introduce basic usage of `g++` (input files and `-o` flag).
3. Introduce students to abstract multi-file program.
4. Attempt to compile the program with `g++ main.cpp -o main`. It should not compile due to double definition.
5. Ask students if anyone knows the problem based on how the preprocessor works.
    - Answer: `TestStruct` is defined twice due to its inclusion in `main.cpp` and its transitive inclusion from `test_compiler_2.h`.
6. Introduce include guards and their alternative, `#pragma once`. Implement them in both header files; note it is best practice to use them in all headers.
7. Attempt to compile the program with the same command. It should not compile due to a linker error.
8. Ask students if anyone knows the problem.
    - Answer: the implementation for `test_func` is in `test_compiler_2.cpp`; this file must be included in the compiler command (unlike header files) because it should be directly compiled (i.e., not used with `#include`) and linked with `main.cpp`
9. The file should compile with `g++ main.cpp test_compiler_2.cpp -o main`.

## Makefile

1. Note that the `g++` command used previously will recompile every file every time it is run. This is inefficient due to the way the linker works (i.e., if `main` changes but `test_compiler_2` does not, then only `main` should be recompiled).
2. Introduce Makefiles and their purpose (build script).
3. Write a simple Makefile using variables, `$^`, and `$@` that compiles the program. Also make a `clean` rule. Explain as you go and as students have questions. Example Makefile:

```
# NOTE: USE TABS NOT SPACES; MAKEFILE DOES NOT ALLOW SPACES
# Might be more than one type of compiler
CXX = g++
CXXFLAGS = --std=c++17

BINARIES = main main2

all: ${BINARIES}

main: main.o test_compiler_2.o
	${CXX} ${CXXFLAGS} $^ -o $@

main2: main2.o
	${CXX} ${CXXFLAGS} $^ -o $@

# Note that header files are only included to update the compilation when they change.
# They do not need to be included in the compilation command, but there is no harm if they are included.
# Note that transitive includes must also be included for this to work properly.
# A more robust solution exists but is out-of-scope for this lesson.
main.o: main.cpp test_compiler.h test_compiler_2.h
	${CXX} ${CXXFLAGS} $^ -c

main2.o: main2.cpp test_compiler.h
	${CXX} ${CXXFLAGS} $^ -c

test_compiler_2.o: test_compiler_2.cpp test_compiler_2.h 
	${CXX} ${CXXFLAGS} $^ -c

# Explain this a bit
# .gch: precompiled header (don't worry about it)
clean:
	rm -rf *.o *.gch ${BINARIES}
```

4. Note how to use GNU `make`, i.e. `make` with no arguments runs the first rule, otherwise specify name of rule.