# protobuf-mutator-example

```shell-session
$ docker build -t protobuf-mutator-example .
$ docker run --rm -it protobuf-mutator-example bash
# ASAN_OPTIONS=detect_leaks=0 ./fuzzer -detect_leaks=0 -len_control=0 -max_len=1000 -runs=1000000 -artifact_prefix=./tmp/ ./tmp/
```
