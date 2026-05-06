#!/bin/sh -x

root=$(pwd)

#********************************************************************
#* Install required packages
#********************************************************************
if test $(uname -s) = "Linux"; then
    # yum works on manylinux2014 (CentOS 7) and is a compat shim on newer images
    yum install -y make gcc gcc-c++ git bison flex gperf
    if test -z $image; then
        image=linux
    fi
    rls_plat=${image}
fi

#********************************************************************
#* Validate environment variables
#********************************************************************
if test -z "${iverilog_version}"; then
    if test -z "${BUILD_NUM}"; then
        iverilog_version="13.0"
    else
        iverilog_version="13.0.${BUILD_NUM}"
    fi
fi

rls_version="${iverilog_version}"

echo "iverilog_version: ${iverilog_version}"
echo "rls_version:      ${rls_version}"
echo "rls_plat:         ${rls_plat}"

#********************************************************************
#* Clone iverilog
#********************************************************************
if test ! -d iverilog; then
    git clone --depth 1 --branch v13_0 https://github.com/steveicarus/iverilog iverilog
    if test $? -ne 0; then exit 1; fi
fi
git config --global --add safe.directory ${root}/iverilog

#********************************************************************
#* Build iverilog
#********************************************************************
release_dir="${root}/release/iverilog"
rm -rf "${release_dir}"
mkdir -p "${release_dir}"

cd ${root}/iverilog
./configure --prefix="${release_dir}" CXXFLAGS="-O2" CFLAGS="-O2"
if test $? -ne 0; then exit 1; fi

make -j$(nproc)
if test $? -ne 0; then exit 1; fi

make install
if test $? -ne 0; then exit 1; fi

# Copy export.envrc for ivpm PATH integration
cp ${root}/scripts/export.envrc "${release_dir}/"

#********************************************************************
#* Create release tarball
#********************************************************************
cd ${root}/release
tar czf iverilog-${rls_plat}-${rls_version}.tar.gz iverilog
if test $? -ne 0; then exit 1; fi

echo "Build complete: release/iverilog-${rls_plat}-${rls_version}.tar.gz"
