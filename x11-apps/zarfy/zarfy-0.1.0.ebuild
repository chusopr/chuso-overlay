# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="GUI to libXrandr"
HOMEPAGE="http://zarfy.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="=x11-libs/gtk+-2*
	gnome-base/libglade
	x11-libs/libXrandr
	x11-libs/libXrender"
RDEPEND="${DEPEND}"

src_unpack()
{
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PV}-distdir.patch"
}

src_install()
{
	einstall || die "Install failed"
	dodoc README
}
