# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: verify=sig https://leancrypto.org/about/index.html
inherit meson-multilib

DESCRIPTION="Lean cryptographic library usable for bare-metal environments "
HOMEPAGE="https://leancrypto.org/"
SRC_URI="https://leancrypto.org/leancrypto/releases/${P}/${P}.tar.xz"

LICENSE="|| ( GPL-2 BSD-2 )"
SLOT="0/1"
KEYWORDS="~amd64"

multilib_src_configure() {
	local emesonargs=()

	meson_src_configure
}

multilib_src_test() {
	# Only run the regression tests rather than the performance ones
	meson_src_test --timeout-multiplier=64 --suite=regression
}

multilib_src_install_all() {
	einstalldocs
}
