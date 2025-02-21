# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

PARMASAN_COMMIT="b4d721aaf9029eb2a6664d7a85b1530fdd027b77"
DESCRIPTION="Parallel make sanitizer"
HOMEPAGE="https://github.com/ispras/parmasan"
SRC_URI="https://github.com/ispras/parmasan/archive/${PARMASAN_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/${PN}-${PARMASAN_COMMIT}

# https://github.com/ispras/parmasan/issues/3
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-build/parmasan-remake"

PATCHES=(
	"${FILESDIR}"/${P}-algorithm-include.patch
)
