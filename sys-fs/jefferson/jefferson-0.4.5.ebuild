# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="JFFS2 filesystem extraction tool"
HOMEPAGE="
	https://github.com/onekey-sec/jefferson
	https://pypi.org/project/jefferson
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/click-8.1.3[${PYTHON_USEDEP}]
	>=dev-python/lzallright-0.2.1[${PYTHON_USEDEP}]
	>=dev-python/python-cstruct-5.2[${PYTHON_USEDEP}]
"
