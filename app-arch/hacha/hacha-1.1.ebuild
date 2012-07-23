# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Hacha for linux allows you to join and split files. Compatible with Hacha for Windows"
HOMEPAGE="http://www.nubbis.com/linux/hacha.html"
SRC_URI="http://trastero.fregona.biz/distfiles/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""

RESTRICT="mirror"

DEPEND="app-arch/tar"
RDEPEND=${DEPEND}

S=${WORKDIR}/${P}

src_install() {
	einstall
	dodoc AUTHORS ChangeLog INSTALL README TODO
}
