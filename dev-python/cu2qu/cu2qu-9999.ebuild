# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
else
	MY_PV="v${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="0130055"
	fi
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A library which converts cubic curves to quadratic in RoboFab objects"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="cython test"

RDEPEND="
	>=dev-python/fonttools-3.32[ufo(-),${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/defcon[${PYTHON_USEDEP}]
	cython? ( >=dev-python/cython-0.28.5[${PYTHON_USEDEP}] )
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
	)
"

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
	export CU2QU_WITH_CYTHON=$(usex cython)
}

python_test() {
	esetup.py test
}
