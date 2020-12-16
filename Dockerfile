FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    gcc git autoconf libtool make clang libc6-dbg \
    ninja-build liblzma-dev libz-dev pkg-config cmake binutils wget tar  \
    nasm curl \
    libtool-bin gettext \
    gdb valgrind vim

WORKDIR /src

# Build libprotobuf
WORKDIR /src
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.14.0/protobuf-all-3.14.0.tar.gz
RUN tar -xf protobuf-all-3.14.0.tar.gz
WORKDIR /src/protobuf-3.14.0
RUN ./configure && \
    make -j8 && \
    make install
RUN ldconfig

# Build libprotobuf-mutator
WORKDIR /src
RUN git clone https://github.com/google/libprotobuf-mutator
WORKDIR /src/libprotobuf-mutator
RUN mkdir build && \
    cd build && \
    cmake .. -GNinja -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Debug && \
    ninja && \
    ninja install

WORKDIR /src/example
COPY fuzzer.cc message.proto Makefile ./
RUN make && \
    mkdir tmp