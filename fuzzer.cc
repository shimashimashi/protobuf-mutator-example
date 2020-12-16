#include <cmath>
#include <iostream>

#include "message.pb.h"
#include "port/protobuf.h"
#include "src/libfuzzer/libfuzzer_macro.h"

DEFINE_PROTO_FUZZER(const Msg& message) {
  // Emulate a bug.
  if (message.optional_string() == "abcdefghijklmnopqrstuvwxyz") {
    if (message.optional_uint64() == 123456789) {
      std::cerr << message.DebugString() << "\n";
      abort();
    }
  }
}
