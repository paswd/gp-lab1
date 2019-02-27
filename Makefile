FLAGS=-ccbin clang++-3.8 -std=c++11 --compiler-options -stdlib=libc++ -Wno-deprecated-gpu-targets
COMPILLER=nvcc

#all: lib start
all: start

#start: main.o
#	$(COMPILLER) $(FLAGS) -o da-lab4 main.o -L. lib/lib-z-search.a

start: gp-lab1.cu
	$(COMPILLER) $(FLAGS) -o gp-lab1 gp-lab1.cu

clean:
	rm gp-lab1
