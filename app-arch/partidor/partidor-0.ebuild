# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Program to split/join files. Compatible with Hacha for Windows"
HOMEPAGE="http://pantuflo.escet.urjc.es/~jvergara"
SRC_URI="http://pantuflo.escet.urjc.es/~jvergara/${PN}.tar.gz
	gtk? ( http://pantuflo.escet.urjc.es/~jvergara/x${PN}.tar.gz )"
LICENSE=""
SLOT="0"
KEYWORDS="~x86"

IUSE="gtk"

RESTRICT="mirror"

DEPEND="gtk? ( =x11-libs/gtk+-1* )"

src_compile()
{
	make -C partidor
	use gtk &&
		make -C xpartidor
}

src_install()
{
	dodoc partidor/README
	doman partidor/partidor.2.gz
	into /usr
	dobin partidor/partidor
	use gtk && dobin xpartidor/xpartidor
}
