#!/bin/bash -x
# Build iverilog for Windows inside an MSYS2 MINGW64 shell.
# Invoked by the CI workflow via msys2/setup-msys2 with shell: msys2 {0}.

set -e

root=$(pwd)

#********************************************************************
#* Install required packages
#********************************************************************
pacman -S --noconfirm --needed \
    gperf \
    ${MINGW_PACKAGE_PREFIX}-cc \
    ${MINGW_PACKAGE_PREFIX}-autotools \
    zip

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
rls_plat="windows-x64"

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

# autoconf.sh is needed in the MSYS2 environment to regenerate configure
# with the correct MINGW host settings.
sh autoconf.sh
if test $? -ne 0; then exit 1; fi

./configure --prefix="${release_dir}" CXXFLAGS="-O2" CFLAGS="-O2"
if test $? -ne 0; then exit 1; fi

make -j$(nproc)
if test $? -ne 0; then exit 1; fi

make install
if test $? -ne 0; then exit 1; fi

#********************************************************************
#* Bundle MINGW runtime DLLs
#* The installed .exe and .dll files link against MINGW DLLs that
#* are not present on a plain Windows system, so we collect them here.
#********************************************************************
mingw_bin="/${MSYSTEM,,}/bin"

bundle_dlls() {
    local binary="$1"
    ldd "$binary" 2>/dev/null \
        | grep -i "${mingw_bin}" \
        | awk '{print $3}' \
        | while read dll; do
            [ -f "$dll" ] && cp -n "$dll" "${release_dir}/bin/" || true
        done
}

for f in "${release_dir}/bin/"*.exe \
          "${release_dir}/lib/ivl/"*.dll \
          "${release_dir}/lib/ivl/"*.vpi; do
    [ -f "$f" ] && bundle_dlls "$f"
done

# Copy export.envrc for ivpm PATH integration
cp ${root}/scripts/export.envrc "${release_dir}/"

#********************************************************************
#* Create release zip
#********************************************************************
cd ${root}/release
zip -r "iverilog-${rls_plat}-${rls_version}.zip" iverilog
if test $? -ne 0; then exit 1; fi

echo "Build complete: release/iverilog-${rls_plat}-${rls_version}.zip"
