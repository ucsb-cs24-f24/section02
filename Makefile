CXX = g++
CXXFLAGS = --std=c++17

BINARIES = main main2

all: ${BINARIES}

main: main.o test_compiler_2.o
	${CXX} ${CXXFLAGS} $^ -o $@

main2: main2.o
	${CXX} ${CXXFLAGS} $^ -o $@

main.o: main.cpp test_compiler.h test_compiler_2.h
	${CXX} ${CXXFLAGS} $^ -c

main2.o: main2.cpp test_compiler.h
	${CXX} ${CXXFLAGS} $^ -c

test_compiler_2.o: test_compiler_2.cpp test_compiler.h test_compiler_2.h
	${CXX} ${CXXFLAGS} $^ -c

clean:
	rm -rf *.o *.gch ${BINARIES}