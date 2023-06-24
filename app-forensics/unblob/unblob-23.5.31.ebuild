# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

UNBLOB_TEST_VERSION=23.5.31
DESCRIPTION="Extract files from any kind of container format"
HOMEPAGE="
	https://github.com/onekey-sec/unblob
	https://pypi.org/project/unblob
"
# The integration test data uses git-lfs, so we need to create our
# own tarball for it & replace the stub files with the real content.
# Created using:
# 1. git config tar.tar.xz.command "xz -c" (one-off)
# 2. git archive --format=tar.xz HEAD tests/integration > unblob-23.5.31-tests.tar.xz
SRC_URI="
	https://github.com/onekey-sec/unblob/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz
	test? ( https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/unblob-${UNBLOB_TEST_VERSION}-tests.tar.xz )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/lief[python,${PYTHON_USEDEP}]
	dev-python/arpy[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/dissect-cstruct[${PYTHON_USEDEP}]
	dev-python/lark[${PYTHON_USEDEP}]
	dev-python/lz4[${PYTHON_USEDEP}]
	dev-python/plotext[${PYTHON_USEDEP}]
	dev-python/pluggy[${PYTHON_USEDEP}]
	dev-python/pyperscan[${PYTHON_USEDEP}]
	dev-python/python-magic[${PYTHON_USEDEP}]
	dev-python/rarfile[${PYTHON_USEDEP}]
	dev-python/structlog[${PYTHON_USEDEP}]
	dev-python/treelib[${PYTHON_USEDEP}]
	dev-python/unblob-native[${PYTHON_USEDEP}]
"
# TODO: Drop unar?
BDEPEND="
	test? (
		app-arch/lziprecover
		app-arch/lzop
		app-arch/p7zip
		app-arch/unar
		app-arch/zstd
		sys-fs/e2fsprogs
		sys-fs/jefferson
		sys-fs/sasquatch
		sys-fs/ubi_reader
		sys-libs/zlib
	)
"

EPYTEST_DESELECT=(
	# debugfs crashes. See https://github.com/tytso/e2fsprogs/issues/152.
	'tests/test_handlers.py::test_all_handlers[filesystem.extfs]'
)

distutils_enable_tests pytest

python_prepare_all() {
	# Avoid pytest-cov
	sed -i \
		-e '/pytest_cov/d' \
		-e '/cleanup_on_sigterm/d' \
		unblob/testing.py || die
	sed -i -e '/--cov/d' pyproject.toml || die

	# Use the non-git-lfs'd test data.
	rm -rf tests/integration || die
	mv "${WORKDIR}"/tests/* tests/ || die

	distutils-r1_python_prepare_all
}

pkg_postinst() {
	# TODO: optfeature?
	# TODO: refresh this list
	# from docs/installation.md
	# app-arch/lziprecover
	# app-arch/lzop
	# app-arch/unar
	# app-arch/zstd
	# sys-fs/e2fsprogs
	# app-arch/p7zip
	# sys-libs/zlib
	:;
}
