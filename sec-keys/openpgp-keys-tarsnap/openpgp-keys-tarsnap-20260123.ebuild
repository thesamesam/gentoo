# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	6D6F81DD4C0442A2F292FFCCD82E72039DF54C96:2025:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by app-backup/tarsnap"
HOMEPAGE="https://www.tarsnap.com/contact.html"
SRC_URI="https://www.tarsnap.com/tarsnap-signing-key-2025.asc"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
