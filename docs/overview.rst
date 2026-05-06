Overview
========

**iverilog-bin** packages `Icarus Verilog
<https://steveicarus.github.io/iverilog/>`_ into manylinux-compatible
release artefacts for Linux, covering glibc 2.17 (manylinux2014) through
glibc 2.34 (manylinux_2_34).

What is Icarus Verilog?
-----------------------

Icarus Verilog (``iverilog``) is an open-source compiler and simulator for
Verilog and a growing subset of SystemVerilog.  It implements much of the
IEEE 1364 Verilog standard and portions of IEEE 1800 SystemVerilog.  It is
widely used for RTL simulation, linting, and as a reference implementation
in open-source EDA flows.

The toolchain consists of two main programs:

* ``iverilog`` — compiles Verilog/SystemVerilog source into an intermediate
  format (or directly to VVP bytecode)
* ``vvp`` — executes the compiled simulation

Why iverilog-bin?
-----------------

Upstream Icarus Verilog is distributed as source only (or through
distribution package managers that may lag behind releases).
**iverilog-bin** provides ready-to-use binaries that:

* Run on any Linux system with glibc ≥ 2.17 (any manylinux2014-compatible
  distribution: CentOS 7+, RHEL 7+, Ubuntu 16.04+, Debian 9+, …).
* Require no build dependencies — just extract and use.
* Are location-independent: the tools discover their module library at
  runtime via ``/proc/self/exe``, so the tarball can be unpacked anywhere.
* Integrate with `IVPM <https://github.com/fvutils/ivpm>`_ so downstream
  projects can declare a binary dependency and have ``PATH`` set
  automatically.

Release naming
--------------

Releases are versioned as ``13.0.<ci-run-id>`` and named::

    iverilog-manylinux2014_x86_64-13.0.<run-id>.tar.gz
    iverilog-manylinux_2_28_x86_64-13.0.<run-id>.tar.gz
    iverilog-manylinux_2_34_x86_64-13.0.<run-id>.tar.gz

Choose the tarball whose manylinux tag matches your system's glibc version
(or pick ``manylinux2014`` for maximum compatibility).

About the patch
---------------

Earlier iverilog-bin releases (for iverilog 10.2) required a source patch
to make the driver and ``vvp`` runtime location-independent.  Starting with
Icarus Verilog v13, the upstream code already uses ``/proc/self/exe`` (Linux)
to locate the module library at runtime, so **no patch is required**.
