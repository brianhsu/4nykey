# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools
MY_PN="MEGAcmd"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/meganz/${MY_PN}.git"
	EGIT_SUBMODULES=( )
else
	MY_PV="267fa1d"
	SRC_URI="
		mirror://githubcl/meganz/${MY_PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi

DESCRIPTION="Command Line Interactive and Scriptable Application to access MEGA"
HOMEPAGE="https://mega.nz/cmd"

LICENSE="BSD-2"
SLOT="0"
IUSE=""

DEPEND="
	>=net-misc/meganz-sdk-3.7.3:=[sodium(+),sqlite]
	dev-libs/libpcre:3[cxx]
	sys-libs/readline:0
"
RDEPEND="
	${DEPEND}
"
DOCS=( README.md build/megacmd/megacmd.changes )
PATCHES=( "${FILESDIR}"/${PN}-sdk373.diff )

src_prepare() {
	sed \
		-e '/SUBDIRS.*sdk/d' \
		-e '/sdk\/m4/d' \
		-e 's:LMEGAINC=.*:PKG_CHECK_MODULES([MEGA],[libmega])\nLMEGAINC=${MEGA_CFLAGS}:' \
		-i Makefile.am configure.ac
	sed \
		-e 's:\$(top_builddir)/sdk/src/libmega\.la:$(MEGA_LIBS):' \
		-e 's:mega_cmd_LDADD = .*:&$(MEGA_LIBS):' \
		-e 's:^mega_exec_CXXFLAGS.*:&\nmega_exec_LDADD=$(MEGA_LIBS):' \
		-e 's:sdk/include/mega/[^ ]\+\.h::g' \
		-e '/sdk\/src\/[^ ]\+\.cpp/d' \
		-i src/include.am
	default
	eautoreconf
}
