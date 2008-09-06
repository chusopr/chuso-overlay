# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Hacha for linux allows you to join and split files. Compatible with Hacha for Windows"
HOMEPAGE="http://www.nubbis.com/linux/hacha.html"
SRC_URI="http://trastero.zamorate.net/distfiles/${P}.tar.gz"
LICENSE=""
SLOT="0"
KEYWORDS="~x86"

IUSE=""

RESTRICT="mirror"

DEPEND="app-arch/tar"

S=${WORKDIR}/${P}

src_unpack() {
	tar xf ${DISTDIR}/${A}
}

src_install() {
	einstall
	dodoc AUTHORS ChangeLog COPYING INSTALL README TODO
}
