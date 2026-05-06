# iverilog-bin

Portable, pre-built distribution of [Icarus Verilog](https://steveicarus.github.io/iverilog/)
for Linux (manylinux2014 / glibc 2.17+ through manylinux_2_34 / glibc 2.34+).

## Quick start

Download the latest tarball from the [Releases](https://github.com/EDAPack/iverilog-bin/releases)
page, extract it, and add `bin/` to your `PATH`:

```sh
tar xzf iverilog-manylinux_2_34_x86_64-<version>.tar.gz
export PATH="$(pwd)/iverilog/bin:${PATH}"
iverilog -V
```

## Building locally

```sh
./scripts/build-local.sh                        # default: manylinux_2_34_x86_64
./scripts/build-local.sh manylinux2014_x86_64   # for maximum glibc compatibility
```

## Documentation

Full documentation is published at https://edapack.github.io/iverilog-bin/

## Notes

- Icarus Verilog v13 locates its module library at runtime via `/proc/self/exe`,
  so the tarball is fully location-independent — **no patch required**.
- The old `scripts/Makefile` and `scripts/iverilog.patch` (for v10.2) are kept
  for historical reference.

