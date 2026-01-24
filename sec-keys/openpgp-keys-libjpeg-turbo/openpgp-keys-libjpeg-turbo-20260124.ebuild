# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	08E2400FF7FE8FEDE3ACB52818147B073BAD2B07:olly:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by media-libs/libjpeg-turbo"
HOMEPAGE="https://libjpeg-turbo.org/Downloads/DigitalSignatures"
SRC_URI="https://raw.githubusercontent.com/libjpeg-turbo/repo/main/LJT-GPG-KEY -> ${P}-LJT-GPG-KEY"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
