# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

DESCRIPTION="LaTeX class for simple curricula vitae."
HOMEPAGE="http://www.ctan.org/tex-archive/help/Catalogue/entries/simplecv.html"
SRC_URI="ftp://cam.ctan.org/tex-archive/macros/latex/contrib/simplecv.zip"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RESTRICT="mirror"

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${PN}"

src_compile() {
	latex simplecv.ins
}

src_install() {
	latex-package_src_install
	dodoc README
}

src_test() {
	latex simplecv.ins || die "build simplecv from simplecv.ins failed"
}

