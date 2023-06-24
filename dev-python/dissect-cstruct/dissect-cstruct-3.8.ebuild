# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Dissect module implementing a parser for C-like structures"
HOMEPAGE="
	https://github.com/fox-it/dissect.cstruct
	https://pypi.org/project/dissect.cstruct/
"
SRC_URI="
	https://github.com/fox-it/dissect.cstruct/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz
"
S="${WORKDIR}"/${PN/-/.}-${PV}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-python/setuptools-scm[${PYTHON_USEDEP}]"

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

distutils_enable_tests pytest
