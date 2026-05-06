Components
==========

iverilog
--------

``iverilog`` is the Verilog/SystemVerilog compiler front-end.  It parses
source files, elaborates the design, and generates code for the ``vvp``
runtime or other back-ends::

    iverilog -o sim.vvp top.v
    iverilog -g2012 -o sim.vvp top.sv   # SystemVerilog 2012

Useful flags:

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Flag
     - Description
   * - ``-g<standard>``
     - Select language standard: ``-g1995``, ``-g2001``, ``-g2005``,
       ``-g2012`` (SystemVerilog 2012)
   * - ``-I<dir>``
     - Add include search directory
   * - ``-D<macro>``
     - Define a preprocessor macro
   * - ``-Wall``
     - Enable all warnings
   * - ``-t <target>``
     - Select code-generation target (default: ``vvp``)

vvp
---

``vvp`` is the simulation runtime that executes ``.vvp`` bytecode files
produced by ``iverilog``::

    vvp sim.vvp

When a design includes ``$dumpfile``/``$dumpvars`` system tasks, ``vvp``
writes a VCD waveform file that can be viewed with GTKWave or similar tools.

iverilog-vpi
------------

``iverilog-vpi`` is a helper script for compiling VPI (Verilog Procedural
Interface) shared objects.  It sets the correct compiler flags to build
a VPI plugin that can be loaded by ``vvp``::

    iverilog-vpi my_vpi.c
    vvp -M. -mmy_vpi sim.vvp

Release layout
--------------

The unpacked release directory contains::

    bin/
      iverilog
      vvp
      iverilog-vpi
    lib/
      ivl/
        (code-generation back-end modules and VPI libraries)
    include/
      iverilog/
        (VPI header files for building extensions)
    share/
      man/man1/
        iverilog.1
        vvp.1
    export.envrc
