# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TJENNESS
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="Search for a file in an environment variable path"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="
	>=virtual/perl-File-Spec-0.800.0
"
DEPEND="dev-perl/Module-Build"
BDEPEND="
	>=dev-perl/Module-Build-0.360.0
"
