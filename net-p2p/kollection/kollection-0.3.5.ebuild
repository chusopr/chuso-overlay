# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils kde-functions fdo-mime
IUSE="KDE"
DESCRIPTION="Kollection is a service menu which opens your emulecollection
files and let you send links to aMule or mldonkey"
HOMEPAGE="http://www.kde-apps.org/content/show.php/Kollection?content=66881"
SRC_URI="http://download.tuxfamily.org/ramielinux/Kollection/${P}.tar.gz"
LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86"
RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}
		kde-base/konqueror
		dev-lang/python"
EMCVER="1.0"
S="${WORKDIR}/amule-emc-${EMCVER}"

src_unpack() {
	unpack ${A} || die "Unpacking ${A} failed!"
	tar jxf ${WORKDIR}/${P}/amule-emc.tar.bz2 || die "Unpacking ${S}/amule-emc.tar.bz2 failed!"
}

src_install() {
	einstall || die "einstall failed"
	cd ../${P}
	dobin amk.py
	set-kdedir
	insinto "${KDEDIR}/share/apps/konqueror/servicemenus"
	doins handleEmc.desktop
	insinto "${KDEDIR}/share"
	doins mimelnk
	dodoc README
}
pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	buildsycoca
}
pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	buildsycoca
}
