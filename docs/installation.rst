Installation
============

From a GitHub Release tarball
-------------------------------

Download the latest tarball from the
`GitHub Releases page <https://github.com/EDAPack/iverilog-bin/releases>`_.
Choose the tarball for your Linux glibc version:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Tarball
     - Minimum glibc
   * - ``iverilog-manylinux2014_x86_64-<ver>.tar.gz``
     - 2.17 (CentOS 7, RHEL 7, Ubuntu 16.04+)
   * - ``iverilog-manylinux_2_28_x86_64-<ver>.tar.gz``
     - 2.28 (AlmaLinux 8, Ubuntu 20.04+)
   * - ``iverilog-manylinux_2_34_x86_64-<ver>.tar.gz``
     - 2.34 (AlmaLinux 9, Ubuntu 22.04+)

Extract it and add the ``bin/`` directory to your ``PATH``::

    tar xzf iverilog-manylinux_2_34_x86_64-<version>.tar.gz
    export PATH="$(pwd)/iverilog/bin:${PATH}"

Verify the tools are available::

    $ iverilog -V
    $ vvp -V

With IVPM
---------

`IVPM <https://github.com/fvutils/ivpm>`_ users can declare a dependency
directly in their project's ``ivpm.yaml``::

    package:
      dep-sets:
        - name: default-dev
          deps:
            - name: iverilog-bin
              src: gh-rls
              url: https://github.com/EDAPack/iverilog-bin

Then run::

    ivpm update

IVPM will prepend the bundled ``bin/`` directory to ``PATH`` automatically
(via the ``env`` section in ``ivpm.yaml``).

System requirements
-------------------

* Linux x86-64 with **glibc ≥ 2.17** (manylinux2014 or newer).
* No additional runtime libraries required — standard system libc is
  sufficient.
