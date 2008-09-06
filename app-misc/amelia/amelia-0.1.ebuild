# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
DESCRIPTION="Increases free disk space by deleting garbage"
HOMEPAGE="http://chuso.net/software/amelia/"
SRC_URI="http://chuso.net/software/amelia/${P}"
LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="mirror"
DEPEND=""
RDEPEND="${DEPEND}
		 gnome-extra/zenity"
S=${WORKDIR}

src_unpack() {
	cp ${DISTDIR}/${A} ${S}/${PN} || die
}

src_install() {
	dobin ${PN} || die
}
