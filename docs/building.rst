Building from Source
====================

iverilog-bin is built inside `manylinux
<https://github.com/pypa/manylinux>`_ Docker containers so the resulting
binaries work on a wide range of Linux distributions.  Three containers
are used, producing tarballs compatible with glibc ≥ 2.17, ≥ 2.28, and
≥ 2.34 respectively.

Prerequisites
-------------

* Docker (any recent version)
* ``git`` with the repository cloned

Build script
------------

The entire build is driven by ``scripts/build.sh``.  The ``build-local.sh``
wrapper invokes it inside the correct Docker container::

    ./scripts/build-local.sh

You can also specify a different manylinux image::

    ./scripts/build-local.sh manylinux2014_x86_64
    ./scripts/build-local.sh manylinux_2_28_x86_64
    ./scripts/build-local.sh manylinux_2_34_x86_64

Or run Docker directly::

    docker run --rm \
        --volume "$(pwd):/io" \
        --env image=manylinux_2_34_x86_64 \
        --workdir /io \
        quay.io/pypa/manylinux_2_34_x86_64 \
        /io/scripts/build.sh

The script performs the following steps:

1. **System dependencies** — installs build tools (``gcc``, ``gcc-c++``,
   ``make``, ``git``, ``bison``, ``flex``, ``gperf``) via ``yum``.

2. **Clone iverilog** — clones
   `steveicarus/iverilog <https://github.com/steveicarus/iverilog>`_ at
   tag ``v13_0`` (if not already present).

3. **Configure** — runs ``./configure --prefix=<release_dir>`` with
   ``-O2`` optimisation flags.

4. **Build** — runs ``make -j$(nproc)``.

5. **Install** — runs ``make install`` into the release staging directory.

6. **Tarball** — packs the release directory into
   ``release/iverilog-<image>-<version>.tar.gz``.

Environment variables
---------------------

.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - Variable
     - Description
   * - ``image``
     - manylinux image name used as the platform tag in the release filename
       (default: ``linux``).
   * - ``iverilog_version``
     - Override the full release version string.  Defaults to
       ``13.0.<BUILD_NUM>`` when ``BUILD_NUM`` is set, or ``13.0`` otherwise.
   * - ``BUILD_NUM``
     - GitHub Actions run ID appended to the version for traceability.

CI / GitHub Actions
-------------------

The workflow in ``.github/workflows/ci.yml`` runs automatically on every
push and on a weekly schedule (Sunday 12:00 UTC).

Steps:

1. **version-check** — constructs the release version string as
   ``13.0.<run-id>``.
2. **build-linux-x86_64** — matrix build across ``manylinux2014_x86_64``,
   ``manylinux_2_28_x86_64``, and ``manylinux_2_34_x86_64``.
3. **publish** — creates a GitHub Release and attaches all three tarballs.

Documentation is built separately and published to GitHub Pages whenever
``main`` is updated (see ``.github/workflows/docs.yml``).

Location independence
---------------------

Icarus Verilog v13 discovers its module library (``lib/ivl/``) at runtime
using ``/proc/self/exe`` rather than a path baked in at compile time.  This
means the tarball can be unpacked to any directory and used without
relocation steps.  No source patch is required (unlike the earlier 10.2
release that shipped with a custom patch in this repository).
