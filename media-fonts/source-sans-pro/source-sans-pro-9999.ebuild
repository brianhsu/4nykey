# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
MY_FONT_TYPES=( otf +ttf )
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${PN}"
else
	inherit vcs-snapshot eapi7-ver
	MY_PVB="$(ver_cut 1-2)R-ro/$(ver_cut 3-4)R-it"
	MY_PV="d975556"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${MY_PVB//R}"
	SRC_URI="
		binary? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${MY_PVB}
			-> ${P%_p*}R.tar.gz
		)
		!binary? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${MY_PV}
			-> ${P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1
MY_MK="3c71e576827753fc395f44f4c2d91131-c8548da"
SRC_URI+="
	!binary? (
		mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
		-> ${MY_MK}.tar.gz
	)
"

DESCRIPTION="Sans serif font family for user interface environments"
HOMEPAGE="https://adobe-fonts.github.io/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-util/afdko[${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	if [[ ${PV} == *9999* ]]; then
		EGIT_BRANCH="$(usex binary release master)"
	elif use binary; then
		S="${WORKDIR}/${P%_p*}R"
	fi

	if use binary; then
		FONT_S=( {O,T}TF )
	else
		python-any-r1_pkg_setup
	fi

	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary || unpack ${MY_MK}.tar.gz
}

src_compile() {
	use binary && return
	emake \
		${FONT_SUFFIX} \
		-f ${MY_MK}/Makefile
}
