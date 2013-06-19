# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils rpm
DESCRIPTION="Generates IceWM menus from XDG entries"

HOMEPAGE="http://www.icewm.org/"

MY_P="${P/xdg-menu/xdgmenu}"
FR="18"
FV="7.fc18"
SRC_URI="mirror://fedora/releases/${FR}/Everything/i386/os/Packages/i/${MY_P}-${FV}.noarch.rpm"

LICENSE="public-domain"

SLOT="0"

KEYWORDS="~amd64 ~ppc ~sparc ~x86"

IUSE=""

RDEPEND="dev-python/pyxdg"

src_install() {
	dobin usr/bin/icewm-xdg-menu
	exeinto /usr/share/icewm
	doexe usr/share/icewm/startup
}
