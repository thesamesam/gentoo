# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="Extremely fast non-cryptographic hash algorithm"
HOMEPAGE="https://xxhash.com/"
SRC_URI="https://github.com/Cyan4973/xxHash/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/xxHash-${PV}

LICENSE="BSD-2 GPL-2+"
# https://abi-laboratory.pro/tracker/timeline/xxhash
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

src_prepare() {
	default

	multilib_copy_sources
}

multilib_src_compile() {
	# https://github.com/Cyan4973/xxHash/blob/a60bd0598d1e3b0b6c6f180ab5cd22936ed85253/xxhash.h#L1583
	append-cppflags -DXXH_FORCE_ALIGN_CHECK=1

	emake AR="$(tc-getAR)" CC="$(tc-getCC)"
}

multilib_src_test() {
	emake CC="$(tc-getCC)" check
}

multilib_src_install() {
	local emakeargs=(
		DESTDIR="${D}"
		PREFIX="${EPREFIX}"/usr
		LIBDIR="${EPREFIX}"/usr/$(get_libdir)
	)

	emake "${emakeargs[@]}" install
	einstalldocs

	rm "${ED}"/usr/$(get_libdir)/libxxhash.a || die
}
