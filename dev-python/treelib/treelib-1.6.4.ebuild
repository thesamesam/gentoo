# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Efficient implementation of tree data structure in Python"
HOMEPAGE="
	http://treelib.readthedocs.io/en/latest/
	https://github.com/caesar0301/treelib
	https://pypi.org/project/treelib/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest
