# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils rpm
DESCRIPTION="Generates IceWM menus from XDG entries"

HOMEPAGE="http://www.icewm.org/"

MY_P="${P/-xdg-menu/}"
FV="-4.fc8"
SRC_URI="mirror://fedora/../development/source/SRPMS/${MY_P}${FV}.src.rpm"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64 ~ppc ~sparc ~x86"

IUSE=""

RDEPEND="dev-python/pyxdg"

S="${WORKDIR}/${P/xdg-menu/xdgmenu}"

src_install() {
	dobin icewm-xdg-menu
}
