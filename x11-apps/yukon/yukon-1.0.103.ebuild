# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="OpenGL video capturing framework"
HOMEPAGE="http://dbservice.com/projects/yukon/"

SRC_URI="http://dbservice.com/ftpdir/tom/yukon/trunk/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="x11-libs/seom"
RESTRICT="mirror"

src_install() {
	einstall DESTDIR="${D}" || die "Install failed"
	insinto /etc
	doins tools/yukon.conf
	insinto /etc/yukon/system
	doins sysconf
}
