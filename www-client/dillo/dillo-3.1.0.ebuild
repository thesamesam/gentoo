# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Lean FLTK based web browser"
HOMEPAGE="https://www.dillo.org/"
SRC_URI="https://github.com/dillo-browser/dillo/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc +gif ipv6 +jpeg +png ssl +xembed"

RDEPEND="
	>=x11-libs/fltk-1.3
	sys-libs/zlib
	jpeg? ( media-libs/libjpeg-turbo )
	png? ( >=media-libs/libpng-1.2 )
	ssl? ( net-libs/mbedtls:= )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	doc? ( app-doc/doxygen )
"

DOCS="AUTHORS ChangeLog README NEWS doc/*.txt doc/README"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable gif)
		$(use_enable ipv6)
		$(use_enable jpeg)
		$(use_enable png)
		$(use_enable ssl tls)
		$(use_enable xembed)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake AR="$(tc-getAR)"

	if use doc; then
		doxygen Doxyfile || die
	fi
}

src_install() {
	default

	use doc && dodoc -r html
}
