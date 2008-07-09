# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="OCRopus is a state-of-the-art document analysis and OCR system"
HOMEPAGE="http://www.ocropus.org"
ESVN_REPO_URI="http://ocropus.googlecode.com/svn/trunk"
ESVN_PATCHES="${PN}-*.diff"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="fst spell readline sdl leptonica verbose-build"

RDEPEND="
	|| ( app-text/tesseract-ocr app-text/tesseract )
	media-libs/iulib
	media-libs/libpng
	media-libs/jpeg
	media-libs/tiff
	fst? ( dev-libs/libfst )
	spell? (
		app-text/aspell
		app-dicts/aspell-en
	)
	readline? ( sys-libs/readline )
	sdl? (
		media-libs/sdl-gfx
		media-libs/sdl-image
	)
	leptonica? ( media-libs/leptonlib )
"
DEPEND="
	${RDEPEND}
	dev-util/scons
"

src_compile() {
	myconf="notesseract=0"
	use fst			|| myconf+=" no-fst=1"
	use spell		|| myconf+=" no-aspell=1"
	use readline	|| myconf+=" no-editline=1"
	use sdl			|| myconf+=" no-sdl=1"
	use leptonica	&& myconf+=" leptonica=1"

	scons \
		${MAKEOPTS} \
		prefix="/usr" \
		opt="${CXXFLAGS}" \
		with-iulib="/usr" \
		with-tesseract="/usr" \
		${myconf} \
		|| die
}

src_install() {
	scons \
		${MAKEOPTS} \
		prefix="${D}/usr" \
		opt="${CXXFLAGS}" \
		with-iulib="/usr" \
		with-tesseract="/usr" \
		${myconf} \
		install || die
	dodoc CHANGES INSTALL README

	insinto /usr/share/ocropus
	doins -r ocroscript/scripts data/{models,words}
}
