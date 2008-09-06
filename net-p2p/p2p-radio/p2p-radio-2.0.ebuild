# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-utils-2
DESCRIPTION="P2P radio streaming"
HOMEPAGE="http://p2p-radio.sourceforge.net/"
SRC_URI="mirror://sourceforge.net/${PN}/P2P-Radio-2.0-src.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
#IUSE="gnome X"
RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN/-/}"
JAVACFLAGS="-sourcepath ."

src_compile() {
	ejavac p2pradio/Radio.java
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
