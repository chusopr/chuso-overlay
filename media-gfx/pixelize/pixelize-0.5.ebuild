# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Converts images to colored HTML"
HOMEPAGE="http://www.sromero.org/wiki/programacion/programas/pixelize"
SRC_URI="http://www.sromero.org/wiki/_media/programacion/programas/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="=media-libs/allegro-4*"
DEPEND=${RDEPEND}

src_install() {
	dobin pixelize textsaic || die "dobin failed"
	dodoc TODO
}
