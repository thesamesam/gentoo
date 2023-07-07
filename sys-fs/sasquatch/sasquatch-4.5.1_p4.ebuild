# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multibuild toolchain-funcs

MY_P=${PN}-v${PV/_p/-}
DESCRIPTION="Fork of sys-fs/squashfs-tools's unsquashfs for vendor squashfs impls"
HOMEPAGE="https://github.com/onekey-sec/sasquatch"
SRC_URI="https://github.com/onekey-sec/sasquatch/archive/refs/tags/${MY_P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug lz4 lzma lzo xattr zstd"

DEPEND="
	sys-libs/zlib
	lz4? ( app-arch/lz4 )
	lzma? ( app-arch/xz-utils )
	lzo? ( dev-libs/lzo )
	xattr? ( sys-apps/attr )
	zstd? ( app-arch/zstd )
"
RDEPEND="${DEPEND}"

MULTIBUILD_VARIANTS=( sasquatch-{le,be} )

use10() {
	usex "${1}" 1 0
}

src_prepare() {
	default
	multibuild_copy_sources
}

src_compile() {
	multibuild_foreach_variant sasquatch_compile
}

sasquatch_compile() {
	cd "${BUILD_DIR}" || die
	# set up make command line variables in EMAKE_SQUASHFS_CONF
	local opts=(
		LZMA_XZ_SUPPORT=$(use10 lzma)
		LZO_SUPPORT=$(use10 lzo)
		LZ4_SUPPORT=$(use10 lz4)
		XATTR_SUPPORT=$(use10 xattr)
		XZ_SUPPORT=$(use10 lzma)
		ZSTD_SUPPORT=$(use10 zstd)
	)

	case "${MULTIBUILD_VARIANT}" in
		sasquatch-be)
			append-cppflags -DFIX_BE
			;;
		*)
			;;
	esac

	tc-export CC
	use debug && append-cppflags -DSQUASHFS_TRACE
	emake "${opts[@]}" -C squashfs-tools
}

src_install() {
	multibuild_foreach_variant sasquatch_install
	dodoc ACKNOWLEDGEMENTS CHANGES README*
}

sasquatch_install() {
	cd "${BUILD_DIR}" || die

	case "${MULTIBUILD_VARIANT}" in
		sasquatch-be)
			newbin squashfs-tools/sasquatch sasquatch-v4be
			;;
		*)
			dobin squashfs-tools/sasquatch
			;;
	esac
}
