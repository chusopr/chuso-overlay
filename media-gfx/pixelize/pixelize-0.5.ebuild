# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Converts images to colored HTML"
HOMEPAGE="http://www.sromero.org/prog/${PN}.html"
SRC_URI="http://www.sromero.org/prog/files/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/allegro"

src_install() {
	dobin pixelize textsaic || die "dobin failed"
	dodoc TODO
}
