# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
inherit cmake distutils-r1 edo toolchain-funcs multiprocessing

# The upstream file is unversioned, so just crank this when it changes
LIEF_TEST_VERSION=0.13.2

DESCRIPTION="Library to Instrument Executable Formats"
HOMEPAGE="
	https://lief-project.github.io/
	https://github.com/lief-project/LIEF/
"
SRC_URI="
	https://github.com/lief-project/LIEF/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz
	test? ( https://data.romainthomas.fr/lief_tests.zip -> ${PN}-${LIEF_TEST_VERSION}-tests.zip )
"
S="${WORKDIR}"/${P^^}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="python test"
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# >=dev-libs/spdlog-1.11.0:=
DEPEND="
	>=dev-cpp/nlohmann_json-3.11.2
	>=dev-libs/utfcpp-3.2.1
	python? ( >=dev-python/pybind11-2.10.1[${PYTHON_USEDEP}] )
"
RDEPEND="${DEPEND}"
BDEPEND="
	python? ( ${DISTUTILS_DEPS} )
	test? ( app-arch/unzip )
"

# Not PATCHES because cmake_src_prepare always applies patches, bug #853805
MY_PATCHES=(
	"${FILESDIR}"/${P}-cmake-respect-flags.patch
	"${FILESDIR}"/${P}-cmake-extra-config.patch
)

handle_python() {
	if use python ; then
		cd api/python || die
		distutils-r1_${EBUILD_PHASE_FUNC}
	fi
}

src_unpack() {
	unpack ${P}.gh.tar.gz

	if use test ; then
		mkdir samples || die
		cd samples || die
		unpack ${PN}-${LIEF_TEST_VERSION}-tests.zip
	fi
}

src_prepare() {
	eapply "${MY_PATCHES[@]}"

	# They otherwise use GNUInstallDirs correctly, so just drop one
	# override line.
	sed -i -e '/set.*CMAKE_INSTALL_LIBDIR/d' CMakeLists.txt || die

	# Just find the system copy normally.
	#sed -i -e '/-Dspdlog_DIR/d' api/python/CMakeLists.txt || die

	cat <<-EOF > api/python/config-default.toml || die
	[lief.build]
	type          = "RelWithDebInfo"
	cache         = false
	ninja         = true
	parallel-jobs = $(makeopts_jobs)
	#extra-cmake-opt = "-DLIEF_OPT_NLOHMANN_JSON_EXTERNAL=ON -DLIEF_OPT_UTFCPP_EXTERNAL=ON -DLIEF_OPT_PYBIND11_EXTERNAL=ON"
	extra-cmake-opt = [ "-DCMAKE_VERBOSE_MAKEFILE=ON", "-DLIEF_OPT_NLOHMANN_JSON_EXTERNAL=ON", "-DLIEF_OPT_UTFCPP_EXTERNAL=ON", "-DLIEF_OPT_PYBIND11_EXTERNAL=ON" ]

	[lief.formats]
	elf     = true
	pe      = true
	macho   = true
	android = true
	art     = true
	vdex    = true
	oat     = true
	dex     = true

	[lief.features]
	json    = true
	frozen  = true

	[lief.logging]
	enabled = true
	debug   = false

	# XXX: Uncomment when using system copy
	#[lief.third-party]
	#spdlog  = "/i/do/not/exist"
	EOF

	cmake_src_prepare
	handle_python
}

src_configure() {
	local mycmakeargs=(
		-DLIEF_TESTS=$(usex test)

		-DLIEF_OPT_NLOHMANN_JSON_EXTERNAL=ON
		-DLIEF_OPT_UTFCPP_EXTERNAL=ON
		-DLIEF_OPT_PYBIND11_EXTERNAL=ON

		# Doesn't install Python bindings properly - and in any case,
		# we'd then be stuck with single-impl.
		-DLIEF_PYTHON_API=OFF

		# Temporarily disabled spdlog because of libfmt breakage
		-DLIEF_EXTERNAL_SPDLOG=OFF

		# Needs >=net-libs/mbedtls-3.2.1 which is masked still (bug #805011)
		-DLIEF_OPT_MBEDTLS_EXTERNAL=OFF

		# Not yet packaged
		-DLIEF_OPT_EXTERNAL_EXPECTED=OFF
		-DLIEF_OPT_EXTERNAL_SPAN=OFF
		-DLIEF_OPT_FROZEN_EXTERNAL=OFF

		# Controlled using PM
		-DLIEF_USE_CCACHE=OFF
	)

	cmake_src_configure
	handle_python
}

src_compile() {
	cmake_src_compile
	handle_python
}

src_test() {
	local -x LIEF_SAMPLES_DIR="${WORKDIR}"/samples

	tc-export CC

	cmake_src_test
	handle_python
}

python_test() {
	sed -i \
		-e "/LIEF_PY_DIR =/ s:.*:LIEF_PY_DIR=Path(\"${S}/api/python/examples\"):" \
		"${S}"/tests/pe/check_python_examples.py || die

	edo ${EPYTHON} "${S}"/tests/run_pytest.py "${BUILD_DIR}"
	edo ${EPYTHON} "${S}"/tests/run_tools_check.py "${WORKDIR}"/${P^^}_build
}

src_install() {
	cmake_src_install
	handle_python
}
