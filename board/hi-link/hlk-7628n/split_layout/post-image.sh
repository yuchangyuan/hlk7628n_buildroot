#!/bin/sh

set -e

TARGETDIR=$1

cat ${BINARIES_DIR}/vmlinux.bin ${BINARIES_DIR}/mt7628an_hilink_hlk-7628n.dtb > ${BINARIES_DIR}/.img0

${HOST_DIR}/bin/lzma-old -z -c ${BINARIES_DIR}/.img0 > ${BINARIES_DIR}/.img1

${HOST_DIR}/bin/mkimage -A mips -O linux -C lzma -a 0x80000000 -e 0x80000000 -d ${BINARIES_DIR}/.img1 ${BINARIES_DIR}/.img2

ksize=$(wc -c < ${BINARIES_DIR}/.img2)
psize=$(expr \( 2048 + 192 \) \* 1024 - $ksize)

tr '\000' '\377' < /dev/zero  | dd bs=1 count=$psize of="${BINARIES_DIR}/.img2.pad"

cat ${BINARIES_DIR}/.img2 ${BINARIES_DIR}/.img2.pad ${BINARIES_DIR}/rootfs.squashfs > ${TARGETDIR}/split_layout.bin
