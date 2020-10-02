# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

inherit eutils
DESCRIPTION="Increases free disk space by deleting garbage"
HOMEPAGE="http://chuso.net/software/amelia/"
SRC_URI="http://chuso.net/software/${PN}/${P}"
LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""
RDEPEND="${DEPEND}
	gnome-extra/zenity"
S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}/${A}" "${S}/${PN}" || die
}

src_install() {
	dobin ${PN} || die
}
