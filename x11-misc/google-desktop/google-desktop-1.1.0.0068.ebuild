# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils rpm

DESCRIPTION="This is a sample skeleton ebuild file"
HOMEPAGE="http://desktop.google.com"
SRC_URI="http://dl.google.com/linux/rpm/stable/i386/${PN}-linux-${PV}.rpm"
LICENSE="Google"
SLOT="0"
KEYWORDS="~x86"
#IUSE="gnome X"
RESTRICT="strip mirror"
DEPEND=">=sys-libs/glibc-2.3.2
		>=x11-libs/gtk+-2.2.0"
RDEPEND="${DEPEND}"

src_install() {
	chown -R root:root ${WORKDIR}
	mv ${WORKDIR}/* ${D}
}
