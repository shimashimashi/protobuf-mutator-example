CXX := clang++
CXXFLAGS := -fno-exceptions -Werror -Wall -Wstring-conversion -g 

all: fuzzer

fuzzer: fuzzer.o message.pb.o
	$(CXX) $(CXXFLAGS) -fsanitize=fuzzer,address -o fuzzer \
	-Wl,-rpath,/usr/local/lib fuzzer.o message.pb.o \
	-L/usr/local/lib -lprotobuf-mutator-libfuzzer -lprotobuf-mutator -lprotobuf -pthread

fuzzer.o: message.pb.h
	$(CXX) $(CXXFLAGS) -fsanitize=fuzzer-no-link -std=gnu++11 \
	-I/usr/local/include/libprotobuf-mutator -I. \
	-c fuzzer.cc

message.pb.o: message.pb.cc
	$(CXX) $(CXXFLAGS) -fsanitize-coverage=0 -std=gnu++11 \
	-I. \
	-c message.pb.cc

message.pb.h message.pb.cc:
	protoc --cpp_out=. message.proto

.PHONY: clean
clean:
	rm *.o *.pb.* fuzzer