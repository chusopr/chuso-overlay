# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_COMPAT=( python{2_5,2_6,2_7} )
inherit python-r1 rpm
DESCRIPTION="Generates IceWM menus from XDG entries"

HOMEPAGE="http://www.icewm.org/"

MY_P="${P/xdg-menu/xdgmenu}"
FR="20"
FV="10.fc20"
SRC_URI="mirror://fedora/releases/${FR}/Everything/i386/os/Packages/i/${MY_P}-${FV}.noarch.rpm"

LICENSE="public-domain"

SLOT="0"

KEYWORDS="~amd64 ~ppc ~sparc ~x86"

IUSE=""

RDEPEND="dev-python/pyxdg"

S=${WORKDIR}

src_install() {
	dobin usr/bin/icewm-xdg-menu
	exeinto /usr/share/icewm
	doexe usr/share/icewm/startup
}
