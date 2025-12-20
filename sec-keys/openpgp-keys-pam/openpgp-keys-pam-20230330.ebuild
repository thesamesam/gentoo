# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	# https://github.com/linux-pam/linux-pam/commit/b7ba550110f2f93fabb50976ea920fcb656c9a8e
	'296D6F29A020808E8717A8842DB5BD89A340AEB7:pam:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by the linux-pam project"
HOMEPAGE="https://github.com/linux-pam/linux-pam"
# pgp.keys.asc in linux-pam.git
SRC_URI="https://raw.githubusercontent.com/linux-pam/linux-pam/b7ba550110f2f93fabb50976ea920fcb656c9a8e/pgp.keys.asc -> ${P}-pam.gpg"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
